#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void encode(char *text, int key) {
    int i;
    for (i = 0; text[i] != '\0'; i++) {
        char ch = text[i];
        if (ch >= 'a' && ch <= 'z') {
            text[i] = ((ch - 'a' + key) % 26) + 'a';
        } else if (ch >= 'A' && ch <= 'Z') {
            text[i] = ((ch - 'A' + key) % 26) + 'A';
        }
    }
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf(1, "Usage: encode/decode text key\n");
        exit();
    }

    char *action = argv[1];
    char *text = argv[2];
    int key = (argc == 4) ? atoi(argv[3]) : 20;

    if (strcmp(action, "encode") == 0) {
        encode(text, key);
    } else if (strcmp(action, "decode") == 0) {
        encode(text, 26 - key);
    } else {
        printf(1, "Invalid action. Use 'encode' or 'decode'.\n");
        exit();
    }

    int text_len = strlen(text);
    char new_text[text_len + 2];
    strcpy(new_text, text);
    new_text[text_len] = '\n';
    new_text[text_len + 1] = '\0';

    int fd = open("result.txt", O_CREATE | O_WRONLY);
    if (fd < 0) {
        printf(1, "Error: Cannot open the file\n");
        exit();
    }
    
    if (write(fd, new_text, strlen(new_text)) != strlen(new_text)) {
        printf(1, "Error writing to file\n");
        exit();
    }

    close(fd);
    exit();
}