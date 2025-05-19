#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[]){
    if(argc != 2){
        printf(2, "Invalid arguments\n");
        exit();
    }
    else{
        int pid = atoi(argv[1]);
        printf(1, "get_most_invoked is called for %d \n", pid);
        int result = get_most_invoked_syscall(pid);
        if(result == -1)
        {
            printf(2, "Invalid process ID.\n");
        }
        else
        {
            printf(1, "The most invoked system call was %d\n", result);
        }

        exit();
    }
}