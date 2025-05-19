#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

#define NUM_OF_ITERR 5
#define TIME_SLICE 10
#define MAX_WAIT 800

int num_of_interr = NUM_OF_ITERR;
int time_slice = TIME_SLICE;
int last_running_pid = 0;

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;
extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

struct {
  struct spinlock lock;
  int syscalls;
} counter_of_syscalls;

void sysinit(void)
{
  initlock(&counter_of_syscalls.lock, "syscall_counter");
}

int check_no_one_in_queue(int queue)
{
  struct proc *p;
  int state = 1;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
  {
    if (p->state == RUNNABLE && p->level_queue == queue) 
    {
        state = 0;
        break;
    }
  }
  return state;
}

void handle_aging_and_consecutive()
{
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) 
  {
    if(p->level_queue != 0)
    {
      if(p->state == RUNNABLE)
      {
        p->wait_cycles++;
        if(p->wait_cycles == MAX_WAIT)
        {
          cprintf("Process %d moved from src:%d to dest:%d\n", p->pid, p->level_queue, p->level_queue - 1);
          change_queue(p->pid, p->level_queue - 1);
        }
      }
      else if(p->state == RUNNING)
      {
        p->wait_cycles = 0;
        if(p->pid != last_running_pid)
        {
          p->consecutive = 1;
        }
        else
        {
          p->consecutive++;
        }
      }
    }
  }
}

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;

    int syscall_id = tf->eax;

    acquire(&counter_of_syscalls.lock);
    if(syscall_id == 15){
      counter_of_syscalls.syscalls += 3;
    }
    else if(syscall_id == 16){
      counter_of_syscalls.syscalls += 2;
    }
    else{
      counter_of_syscalls.syscalls++;
    }
    release(&counter_of_syscalls.lock);

    if(syscall_id == 15){
      cli();
      mycpu()->syscall_counter += 3;
      sti();
    }
    else if(syscall_id == 16){
      cli();
      mycpu()->syscall_counter += 2;
      sti();
    }
    else{
      cli();
      mycpu()->syscall_counter++;
      sti();
    }

    syscall();
    if(myproc()->killed)
      exit();
    return;
  }
  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      handle_aging_and_consecutive();
      num_of_interr--;
      time_slice--;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }


  

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
  
  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
  {
    int flag = 0;
    //RR
    if(mycpu()->RR > 0)
    {
      if(time_slice <= 0)
      {
        time_slice = TIME_SLICE;
        mycpu()->RR--;
        if((mycpu()->RR == 0) || (check_no_one_in_queue(0)))
        {
          // cprintf("RR time is over %d.\n", mycpu()->RR);
          mycpu()->SJF = 2;
          flag = 1;
          yield();
          
        }
      }
      if((num_of_interr <= 0) && (flag == 0))
      {
        yield();
        num_of_interr = NUM_OF_ITERR;
      }
    }
    //SJF and FCFS
    else
    {
      if(time_slice <= 0)
      {
        time_slice = TIME_SLICE;
        if(mycpu()->SJF > 0)
        {
            mycpu()->SJF--;
            if((mycpu()->SJF == 0) || (check_no_one_in_queue(1)))
            {
              // cprintf("SJF time is over %d.\n", mycpu()->SJF);
              mycpu()->FCFS = 1;
              yield();
            }
        }
        else if(mycpu()->FCFS > 0)
        {
          mycpu()->FCFS--;
          if((mycpu()->FCFS == 0) || (check_no_one_in_queue(2)))
          {
            // cprintf("FCFS time is over %d.\n", mycpu()->FCFS);
            mycpu()->RR = 3;
            yield();
          }
        }
      }
    }
  
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
