#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"

int main()
{
    for(int i = 0; i < 3; i++)
    {
        int pid = fork();
        // printf(1, "Pid %d forked.\n", pid);
        if(pid == 0)
        {
            test_lock();
            exit();
        }
    }
    
    for(int j = 0; j < 3; j++)
    {
        wait();
    }
    exit();
}