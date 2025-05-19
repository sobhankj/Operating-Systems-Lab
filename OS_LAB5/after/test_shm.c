#include "types.h"
#include "stat.h"
#include "user.h"
#include "IPC.h"
#include "SHM.h"
#include "memlayout.h"

#define SHM_KEY 1000
#define NUM_CHILD_PROCESSES 7

int main(int argc, char *argv[]) {
    int shared_mem_id = get_shared_mem(SHM_KEY, sizeof(int), 0);
    if (shared_mem_id < 0) {
        shared_mem_id = get_shared_mem(SHM_KEY, sizeof(int), 06 | IPC_CREAT);
        if (shared_mem_id < 0) {
            printf(1, "Failed to create shared memory segment\n");
            exit();
        }
        int *shared_mem_ptr = (int *)attach_shared_mem(shared_mem_id, 0, 0);
        if ((int)shared_mem_ptr < 0) {
            printf(1, "Failed to attach shared memory segment\n");
            exit();
        }
        *shared_mem_ptr = 0;
        deattach_shared_mem(shared_mem_ptr);
    }
    for (int i = 0; i < NUM_CHILD_PROCESSES; i++) {
        int pid = fork();
        if (pid < 0) {
            printf(1, "Fork failed\n");
            exit();
        } else if (pid == 0) {
            int child_shared_mem_id = get_shared_mem(SHM_KEY, sizeof(int), 0);
            if (child_shared_mem_id < 0) {
                printf(1, "Failed to get shared memory segment\n");
                exit();
            }
            int *child_shared_mem_Ptr = (int *)attach_shared_mem(child_shared_mem_id, 0, 0);
            if ((int)child_shared_mem_Ptr < 0) {
                printf(1, "Failed to attach shared memory segment\n");
                exit();
            }
            if(i != 0)
                *child_shared_mem_Ptr *= i + 1;
            else
                *child_shared_mem_Ptr = 1;
            deattach_shared_mem(child_shared_mem_Ptr);
            exit();
        }
    }
    for (int i = 0; i < NUM_CHILD_PROCESSES; i++) {
        wait();
    }
    int *parent_shared_mem_Ptr = (int *)attach_shared_mem(shared_mem_id, 0, 0);
    if ((int)parent_shared_mem_Ptr < 0) {
        printf(1, "Failed to attach shared memory segment\n");
        exit();
    }
    printf(1, "Total amount of memory: %d\n", *parent_shared_mem_Ptr);
    deattach_shared_mem(parent_shared_mem_Ptr);

    remove_shared_mem(shared_mem_id, IPC_RMID, 0);

    exit();
}