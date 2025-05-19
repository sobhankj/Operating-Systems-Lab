#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char* argv[]){
    if(argc != 1){
        printf(2, "Invalid arguments!\n");
        exit();
    }
    else{
        list_all_processes();
        printf(1, "Listing completed!\n");
        exit();
    }
}