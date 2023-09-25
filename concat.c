#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Usage: concat str0 str1 str2 ...\n");
        return 1;
    }
    if (argc == 2) {
        printf("%s\n", argv[1]);
        return 1;
    }
    char* buf = (char*) malloc(1024 * sizeof(char));
    int buf_idx = 0;
    for (int i = 1; i < argc; i++) {
        int len = strnlen(argv[i], 1024);
        for (int j = 0; j < len; j++) {
            buf[buf_idx] = argv[i][j];
            buf_idx++;
            if (buf_idx >= 1024) {
                printf("Buffer overflow, please make your strings shorter.\n");
                free(buf);
                return 1;
            }
        }
    }
    buf[buf_idx] = '\0';
    printf("%s\n", buf);
    free(buf);
    return 0;
}