#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "reentrantlock.h"

#define DEFAULT_BURST 2
#define DEFAULT_CERTAINTY 50
extern int check_no_one_in_queue(int queue);
extern uint ticks;

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;
struct proc *sorted_procs[NPROC];
static struct reentrantlock testing_lock;
int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

int sort_pcbs_by_burst(void) {
    struct proc *p;
    int count = 0;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == RUNNABLE && p->level_queue == 1) {
            // cprintf("%d is ready\n", p->pid);
            sorted_procs[count++] = p;
        }
    }

    for (int i = 1; i < count; i++) {
        struct proc *key = sorted_procs[i];
        int j = i - 1;
        while (j >= 0 && sorted_procs[j]->burst > key->burst) {
            sorted_procs[j + 1] = sorted_procs[j];
            j--;
        }
        sorted_procs[j + 1] = key;
    }
    return count;
}
void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

int SJF_init(int pid, int burst, int certainty){
  if(certainty > 100 || certainty < 0)
    return -1;
  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->burst = burst;
      p->certainty = certainty;
      break;
    }
  }
  release(&ptable.lock);
  return 0;
}

void change_queue(int pid , int dest_Q){
  if(dest_Q < 0)
    cprintf("error\n");
  else
  {
    struct proc* p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid == pid){
        if(p->level_queue != dest_Q){
          p->level_queue = dest_Q;
          p->wait_cycles = 0;
          p->queue_arrival = ticks;
        }
        else{
          cprintf("Process is already in queue %d!\n", dest_Q);
        }
        break;
      }
    }
    release(&ptable.lock);
  }
}

void printTableHeader() 
{
    cprintf("name      pid  state  queue wait       conf      burst   cons    arrival\n");
    cprintf("---------------------------------------------------------------------------\n");
}

char* stateToStr(enum procstate state) 
{ 
 switch(state)
 { 
    case UNUSED: return "UNUSED";
    case EMBRYO: return "EMBRYO";
    case SLEEPING: return "SLEEPING";
    case RUNNABLE: return "RUNNABLE"; 
    case RUNNING: return "RUNNING";
    case ZOMBIE: return "ZOMBIE";
    default: return "UNKNOWN"; 
  }
}

void print_info() 
{
    printTableHeader();
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if(p->state != UNUSED)
      {
        cprintf("%s", p->name); 
        int len = strlen(p->name);
        for(int i = len; i < 10; i++) cprintf(" ");

        cprintf("%d", p->pid);                   
        if(p->pid < 10) cprintf("   ");
        else if(p->pid < 100) cprintf("  ");
        else cprintf(" ");

        cprintf("%s", stateToStr(p->state));       
        len = strlen(stateToStr(p->state));
        for(int i = len; i < 10; i++) cprintf(" ");

        cprintf("%d    ", p->level_queue);
        cprintf("%d          ", p->wait_cycles);
        cprintf("%d        ", p->certainty);
        cprintf("%d        ", p->burst);
        cprintf("%d        ", p->consecutive);
        cprintf("%d\n\n", p->arrival);
      }
    }
    release(&ptable.lock);
}
	


// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->syscall_count = 0;
  p->arrival = ticks;
  p->last_exec = ticks; 
  p->burst = DEFAULT_BURST;
  p->certainty = DEFAULT_CERTAINTY;
  p->queue_arrival = ticks;
  p->consecutive = 0;

  if((p->pid == 1) || (p->pid == 2))
  {
    p->level_queue = 0;
  }
  else if((p->parent->pid == 1) || (p->parent->pid == 2))
  {
    p->level_queue = 0;
  }
  else
  {
    p->level_queue = 2;
  }

   for(int i = 0; i < SHAREDREGIONS; i++) {
    // default values
    p->pages[i].key = -1;
    p->pages[i].shared_mem_id = -1;
    p->pages[i].size  = 0;
    p->pages[i].perm = PTE_W | PTE_U;
    p->pages[i].virtual_addr = (void *)0;
  }

  //set_times
  memset(p->syscall_history, 0, sizeof(p->syscall_history));
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;
  p->level_queue = 0;
  p->arrival = ticks;
  p->last_exec = ticks;
  p->burst = DEFAULT_BURST;
  p->certainty = DEFAULT_CERTAINTY;
  p->queue_arrival = ticks;
  p->consecutive = 0;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }
  
  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  for(int i = 0; i < SHAREDREGIONS; i++) {
    if(curproc->pages[i].key != -1 && curproc->pages[i].shared_mem_id != -1) {
      np->pages[i] = curproc->pages[i];
      // get valid shmid index in shmtable-allRegions struct
      int index = get_shared_mem_id_index(np->pages[i].shared_mem_id);
      if(index != -1) {
        // map them to child's address space
        mappages_wrapper(np, index, i);
      }
    }
  }
  
  if((np->parent->pid == 2) || (np->parent->pid == 1))
  {
    np->level_queue = 0;
  }
  np->wait_cycles = 0;
  // cprintf("pid %d forked by level %d\n", pid, np->level_queue);

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

int find_min_last_exec()
{
  struct proc *p;
  int min = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
      if((p->level_queue == 0) && (p->pid != 0) && (p->state == RUNNABLE))
      {
        min = p->last_exec;
        break;
      }
  }
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
      if((p->level_queue == 0) && (p->pid != 0) && (p->state == RUNNABLE))
      {
        if(p->last_exec < min)
        {
          min = p->last_exec;
        }
      }
  }
  return min;
}

int find_first_come()
{
  struct proc *p;
  int FC = 0;
  // int pid = -10;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
      if((p->level_queue == 2) && (p->pid != 0) && (p->state == RUNNABLE))
      {
        FC = p->arrival;
        // pid = p->pid;
        break;
      }
  }
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
      if((p->level_queue == 2) && (p->pid != 0) && (p->state == RUNNABLE))
      {
        if(p->arrival < FC)
        {
          FC = p->arrival;
          // pid = p->pid;
        }
      }
  }

  // cprintf("FIRST COME IS %d BY ARRIVAL %d\n", pid, FC);
  return FC;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    //This is for RR
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(mycpu()->RR)
      {
        if(check_no_one_in_queue(0))
        {
          mycpu()->RR = 0;
          mycpu()->SJF = 2;
          break;
        }
        if((p->state != RUNNABLE) || (p->level_queue != 0))
          continue;
        // if(p->pid > 2)
        //   cprintf("pid %d is in %d\n", p->pid , p->level_queue);
        int min_last_exec = find_min_last_exec();
        if(p->last_exec == min_last_exec)
        {
          c->proc = p;
          // cprintf("TICKS: %d PID: %d exec...\n", ticks, p->pid);
          switchuvm(p);
          p->state = RUNNING;

          swtch(&(c->scheduler), p->context);
          p->last_exec = ticks;
          switchkvm();

          c->proc = 0;
        }
      }
    }
    // SJF
    for(int j = 0; j < NPROC; j++){
      // if(mycpu()->SJF)
      // {
        int count = sort_pcbs_by_burst();
        int seed = (ticks * 17) % 100;
        if(count > 0)
        {
          // cprintf("count is: %d and seed is %d\n", count, seed);
          struct proc *p = sorted_procs[count - 1];
          for (int i = 0; i < count; i++) {
            // cprintf("%d. certainty: %d\n", sorted_procs[i]->pid, sorted_procs[i]->certainty);
              if (sorted_procs[i]->certainty > seed) {
                  p = sorted_procs[i];
                  // Run the process with the shortest burst time
                  break;
              }
          }
          // cprintf("shortest is: %d with burst: %d and certainty: %d\n", p->pid, p->burst, p->certainty);
          c->proc = p;
          switchuvm(p);
          p->state = RUNNING;
          swtch(&(c->scheduler), p->context);
          switchkvm();
          c->proc = 0;
        }
        else
        {
          mycpu()->SJF = 0;
          mycpu()->FCFS = 1;
        }
      // }
    }
    //FCFS
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(mycpu()->FCFS)
      {
        // cprintf("SJF: %d\n", mycpu()->SJF);
        if(!check_no_one_in_queue(2))
        {
          if((p->state != RUNNABLE) || (p->level_queue != 2))
            continue;
          int first_come = find_first_come();
          if(p->arrival == first_come)
          {
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
            switchkvm();
            c->proc = 0;
          }
        }
        else
        {
          mycpu()->FCFS = 0;
          mycpu()->RR = 3;
        }
      }
    }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


int create_palindrome(int num){
  int reversed = 0;
  int temp = num;
  int num_of_digits = 0;

  while (temp > 0) 
  {
      reversed = reversed * 10 + (temp % 10);
      temp /= 10;
      num_of_digits += 1;
  }

  int palindrome = reversed;
  int powers_of_ten = 1;
  for(int i = 0; i < num_of_digits; i++)
  {
      powers_of_ten *= 10;
  }
  palindrome += (num * powers_of_ten);
  return palindrome;
}

int sys_get_most_invoked_syscall(void){
  int pid;
  if(argint(0, &pid) < 0){
    return -1;
  }

  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      int max = p->syscall_history[0];
      int index = 1;
      for(int i = 0; i < SYSCALL_NUM; i++){
        if(p->syscall_history[i] > max){
          max = p->syscall_history[i];
          index = i + 1;//for array index
        }
      }
      release(&ptable.lock);
      return index;
    }
  }
  release(&ptable.lock);
  return -1;
}

int sys_sort_syscalls(void){
  int pid;
  if(argint(0, &pid) < 0){
    return -1;
  }

  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if((p->pid == pid) && (p->pid > 0)){
      cprintf("Sorted system calls of %d/frequencies:\n", pid);
      for(int i = 0; i < SYSCALL_NUM; i++)
      {
        if(p->syscall_history[i] > 0)
          cprintf("system call %d : %d\n", i + 1, p->syscall_history[i]);
      } 
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

void sys_list_all_processes(void){
  struct proc* p;
  acquire(&ptable.lock);
  cprintf("Processes Info:\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid > 0)
      cprintf("Process %d -> %d systemcalls\n", p->pid, p->syscall_count);
    else
    {
      release(&ptable.lock);
      break;
    }
  }
}

void recursive_lock_test(int depth) 
{
    if (depth == 0) 
    {
        return;
    }

    cprintf("Acquiring lock at depth %d pid %d\n", depth, myproc()->pid);
    acquirereentrantlock(&testing_lock);

    recursive_lock_test(depth - 1);

    cprintf("Releasing lock at depth %d pid %d\n", depth, myproc()->pid);
    releasereentrantlock(&testing_lock);
}

void test_lock() 
{
    cprintf("Testing reentrant lock...\n");

    // // Non-recursive case
    cprintf("Acquiring lock (non-recursive)...\n");
    acquirereentrantlock(&testing_lock);
    cprintf("Lock acquired. Releasing lock...\n");
    releasereentrantlock(&testing_lock);
    cprintf("Lock released.\n");

    // Recursive case
    cprintf("Starting recursive lock test...\n");
    recursive_lock_test(3);
    cprintf("Recursive lock test completed.\n");
}

void init_reentrantlock_test(void)
{
  cprintf("Initializing reentrant lock...\n");
  initreentrantlock(&testing_lock, "test_lock");
}
