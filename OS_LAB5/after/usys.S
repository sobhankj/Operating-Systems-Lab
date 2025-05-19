#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(create_palindrome)
SYSCALL(move_file)
SYSCALL(get_most_invoked_syscall)
SYSCALL(sort_syscalls)
SYSCALL(list_all_processes)
SYSCALL(SJF_init)
SYSCALL(change_queue)
SYSCALL(print_info)
SYSCALL(test_lock)
SYSCALL(get_shared_mem)
SYSCALL(deattach_shared_mem)
SYSCALL(attach_shared_mem)
SYSCALL(remove_shared_mem)