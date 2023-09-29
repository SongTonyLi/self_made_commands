#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    if (argc != 4) {
        printf("Usage: strReplace strInput substring repl.\n");
        return 1;
    }
    char* strInput = argv[1];
    int inputLen = strlen(strInput);
    char* substring = argv[2];       
    int subLen = strlen(substring); 
    char* repl = argv[3];
    int replLen = strlen(repl);      

    if (subLen > inputLen) {
        printf("Invalid substring.\n");
        return 1;
    }

    int replaceIdx[1024];
    int count = 0;

    for (int i = 0; i <= inputLen - subLen; i++) { 
        if (strncmp(strInput + i, substring, subLen) == 0) {
            replaceIdx[count] = i;
            count++;
            i += subLen - 1; 
        }
    }

    char* out = (char*) malloc(inputLen + (count * (replLen - subLen)) + 1); 
    int idx = 0;
    int replIdx = 0;

    for (int i = 0; i < inputLen; i++) {
        if (replIdx < count && i == replaceIdx[replIdx]) {
            for (int k = 0; k < replLen; k++) {
                out[idx++] = repl[k];
            }
            i += subLen - 1; 
            replIdx++;
        } else {
            out[idx++] = strInput[i];
        }
    }
    out[idx] = '\0';
    printf("%s\n", out);
    free(out);
    return 0; 
}
