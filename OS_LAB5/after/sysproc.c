#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

// extern struct proc proc[NPROC];

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_create_palindrome(void){
  int n = myproc()->tf->ebx;
  cprintf("KERNEL: sys_create_palindrome(%d)\n", n);
  return create_palindrome(n);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_SJF_init(void){
  int pid, burst, certainty;
  if(argint(0, &pid) < 0 || argint(1, &burst) < 0 || argint(2, &certainty) < 0)
    return -1;
  return SJF_init(pid, burst, certainty); 
}

void sys_change_queue(void){
  int pid, dest_Q;
  if(argint(0, &pid) < 0 || argint(1, &dest_Q) < 0 || argint(1, &dest_Q) > 2){
    cprintf("Invalid arguments!\n");
    return;
  }
  return change_queue(pid, dest_Q);
}

void sys_print_info(void){
  return print_info();
}

void sys_test_lock(void){
  test_lock();
}

extern int get_shared_mem(uint, uint, int);
extern int deattach_shared_mem(void*);
extern void * attach_shared_mem(int, void*, int);
extern int remove_shared_mem(int, int, void*);

int
sys_get_shared_mem(void)
{
  int key, size, shmflag;
  // check for valid arguments
  if(argint(0, &key) < 0)
    return -1;
  if(argint(1, &size) < 0)
    return -1;
  if(argint(2, &shmflag) < 0)
    return -1;
  return get_shared_mem((uint)key, (uint)size, shmflag);
}

int sys_deattach_shared_mem(void)
{
  int i;
  // check for valid argument
  if(argint(0,&i)<0)
    return 0;
  return deattach_shared_mem((void*)i);
}

// system call handler for attach_shared_mem
void*
sys_attach_shared_mem(void)
{
  int shmid, shmflag;
  int i;
  // check for valid arguments
  if(argint(0, &shmid) < 0)
    return (void*)0;
  if(argint(1,&i)<0)
    return (void*)0;
  if(argint(2, &shmflag) < 0)
    return (void*)0;
  return attach_shared_mem(shmid, (void*)i, shmflag);
}

// system call handler for remove_shared_mem
int
sys_remove_shared_mem(void)
{
  int shmid, cmd, buf;
  // check for valid arguments
  if(argint(0, &shmid) < 0)
    return -1;
  if(argint(1, &cmd) < 0)
    return -1;
  if(argint(2, &buf) < 0)
    return -1;
  return remove_shared_mem(shmid, cmd, (void*)buf);
}