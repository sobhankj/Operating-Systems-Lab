#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char* argv[]){
    if(argc != 3){
        printf(2, "You didn't provide valid arguments!\n");
        exit();
    }
    else{
        int return_value = move_file(argv[1], argv[2]);
        if(return_value == -1){
            printf(2, "moving file was unsuccessful\n");
            exit();
        }
        else{
            printf(1, "moving was successful!\n");
            exit();
        }
    }
}