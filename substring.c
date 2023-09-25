#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void sub(char* s, int st, int ed) {
    char out[1024];
    int j = 0;
    for (int i = st; i < ed; i++) {
        out[j] = s[i];
        j++;
    }
    out[j] = '\0';
    printf("%s\n", out);
}

int main(int argc, char* argv[]) {
    if (argc != 3 && argc != 4) {
        printf("Usage: substring str startIndex optional_endIndex(not included)\n");
        return 1;
    }
    int len = strnlen(argv[1], 1024);
    int start = atoi(argv[2]);
    int end;
    if (argc == 3) 
        end = len;
    else 
        end = atoi(argv[3]);
    if (start < 0) {
        if (-start > len) {
            printf("Error: Invalid Indexing\n");
            return 1;
        }
        start += len;
    }
    if (end < 0) {
        if (-end > len) {
            printf("Error: Invalid Indexing\n");
            return 1;
        }
        end += len;
    }
    if (end < start) {
        printf("Error: Invalid Indexing\n");
        return 1;
    }
    sub(argv[1], start, end);
    return 0;
}