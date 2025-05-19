#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"  
#include "reentrantlock.h" 

void initreentrantlock(struct reentrantlock *rl, char *name) 
{
    initlock(&rl->lock, name);
    rl->owner = 0;             
    rl->recursion = 0;       
}

void acquirereentrantlock(struct reentrantlock *rl) 
{
    pushcli(); // Disable interrupts to prevent deadlock

    struct proc *p = myproc();

    if (rl->owner == p) 
    {
        rl->recursion++;
        popcli();
        return;
    }

    acquire(&rl->lock);
    rl->owner = p;        
    rl->recursion = 1;        

    popcli(); // Re-enable interrupts
}

void releasereentrantlock(struct reentrantlock *rl) {
    pushcli(); // Disable interrupts

    if (rl->owner != myproc()) 
    {
        panic("releasereentrantlock: not owner");
    }

    if (rl->recursion > 1) 
    {
        rl->recursion--;
        popcli();
        return;
    }

    rl->owner = 0;           
    rl->recursion = 0;        
    release(&rl->lock); 

    popcli(); // Re-enable interrupts
}
