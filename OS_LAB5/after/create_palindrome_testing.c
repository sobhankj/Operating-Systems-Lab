#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[]){
    if(argc != 2){
        if(argc < 2)
            printf(1, "you didn't enter the argument\n");
        else
            printf(1, "too many arguments\n");

        exit();
    }
    int last_ebx_value;
    int number = atoi(argv[1]);

    asm volatile (
        "movl %%ebx, %0;"
        "movl %1, %%ebx;"
        :"=r" (last_ebx_value)
        :"r" (number)
    );
    printf(1, "create_palindrome is called for %d \n", number);
    int answer = create_palindrome(number);
    printf(1, "The palindrome of number %d is: %d\n", number, answer);

    asm("movl %0, %%ebx"
            :
            : "r"(last_ebx_value)
    );
    exit();
}