//this for type int char
#include"types.h"

//this for we can use getpid()
#include"user.h"

int main(int argc , char*argv[]) {
    int pid = getpid();
    printf(1 , "hi :)\nwe can getpid and this is the pid : %d\n" , pid);
    exit();
}
