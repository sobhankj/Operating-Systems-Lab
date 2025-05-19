#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"

#define FILE_COUNT 10
#define WRITE_COUNT 10
#define FILENAME_LEN 20
#define BUFFER_SIZE 64

void int_to_string(int num, char *str) {
    char temp[10];
    int i = 0, j = 0;

    // Convert number to string (reverse order)
    do {
        temp[i++] = '0' + (num % 10);
        num /= 10;
    } while (num > 0);

    // Reverse the string into the final buffer
    while (i > 0) {
        str[j++] = temp[--i];
    }
    str[j] = '\0';
}

void string_append(char *dest, const char *src) {
    while (*dest) {
        dest++; // Move to the end of the destination string
    }
    while (*src) {
        *dest++ = *src++; // Append source string to destination
    }
    *dest = '\0'; // Null-terminate the resulting string
}

void file_stress_test() {
    char filename[FILENAME_LEN];
    char buffer[BUFFER_SIZE];
    int fd;

    // Fill the buffer with dummy data
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
        buffer[i] = 'A' + (i % 26); // Cycles through A-Z
    }
    buffer[BUFFER_SIZE - 1] = '\0';

    // Create and write to multiple files
    for (int i = 0; i < FILE_COUNT; i++) {
        // Format the filename manually
        strcpy(filename, "file");
        int_to_string(i, filename + 4); // Append number after "file"
        string_append(filename, ".txt");

        fd = open(filename, O_CREATE | O_RDWR);
        if (fd < 0) {
            printf(1, "Failed to open file %s\n", filename);
            exit();
        }

        for (int j = 0; j < WRITE_COUNT; j++) {
            if (write(fd, buffer, BUFFER_SIZE) != BUFFER_SIZE) {
                printf(1, "Write failed for file %s on iteration %d\n", filename, j);
                close(fd);
                exit();
            }
        }

        printf(1, "Completed writing to %s\n", filename);
        close(fd);
    }
}

int main() {
    printf(1, "Starting file stress test...\n");
    file_stress_test();
    printf(1, "File stress test completed.\n");
    syscall_info();
    exit();
}
