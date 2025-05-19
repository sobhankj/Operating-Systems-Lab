#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf(1, "Invalid argumrnts\n");
        exit();
    }

    if (move_file(argv[1], argv[2]) == 0) {
        printf(1, "copy_file executed successfully.\n");
    } else {
        printf(1, "Error during copy_file execution\n");
    }

    exit();
}

