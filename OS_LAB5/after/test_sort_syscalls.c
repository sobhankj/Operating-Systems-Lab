#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char* argv[]){
    if(argc != 2){
        printf(2, "You didn't provide valid arguments!\n");
        exit();
    }
    else{
        int return_value = sort_syscalls(atoi(argv[1]));
        if(return_value == -1){
            printf(2, "Invalid Process ID.\n");
            exit();
        }
        else{
            printf(1, "Sorting compeleted!\n");
            exit();
        }
    }
}