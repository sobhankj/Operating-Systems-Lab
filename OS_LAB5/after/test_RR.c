#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_CHILDREN 40
#define ITERATIONS 4000

int main() 
{ 
    for (int r = 0; r < NUM_CHILDREN; r++) 
    {
        int pid = fork();

        if (pid < 0) 
        {
            printf(1, "Fork failed for child %d\n", r);
            exit();
        } 
        else if (pid == 0) 
        {
            volatile int sum = 0; 
            for (int i = 0; i < ITERATIONS; i++) 
            {
                for (int j = 0; j < ITERATIONS / 10; j++) 
                {
                    sum += (i * j) % (r + 1);  
                    if((i == ITERATIONS/2) && (j == ITERATIONS/20))
                    {
                        print_info();
                    }
                }
            }
            exit(); 
        }

        SJF_init(pid, (pid*7)%13, r*pid%100);
    }

    for (int i = 0; i < NUM_CHILDREN; i++) {
        if (wait() < 0) 
        {
            printf(1, "Wait failed for child %d\n", i);
            exit();
        }
    }
    exit();
}
