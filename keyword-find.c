#include <stdio.h>
#include <dirent.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>

int iterate(DIR* dr, char* keyword, bool recursive, char prefix[1024]) {
    struct dirent* de;
    if (dr == NULL) {
        printf("Could not open current directory\n");
        return 1;
    }

    while ((de = readdir(dr)) != NULL) {
        char* fileName = de->d_name;
        bool isPresent = false;
        for (int i = 0; fileName[i] != '\0'; i++) {
            isPresent = false;
            for (int j = 0; keyword[j] != '\0'; j++) {
                if (fileName[i + j] != keyword[j]) {
                    isPresent = false;
                    break;
                }
                isPresent = true;
            }
            if (isPresent) {
                printf("%s/%s\n", prefix, de->d_name);
                break;
            }
        }
        struct stat path_stat;
        char fullpath[1024];
        sprintf(fullpath, "%s/%s", prefix, fileName);
        stat(fullpath, &path_stat);
        if (S_ISDIR(path_stat.st_mode) == 1 && recursive && strcmp(fileName, ".") != 0 && strcmp(fileName, "..") != 0) {
            DIR* subdr = opendir(fullpath);
            if (subdr != NULL) {
                iterate(subdr, keyword, recursive, fullpath);
            }
        }
    }
    closedir(dr);
    return 0; 
}

int main(int argc, char *argv[]) {
    if (argc < 2 || argc > 3 || (argc == 3 && strcmp(argv[1], "-r") != 0)) {
        printf("Usage: %s <keyword> or %s -r <keyword>\n", argv[0], argv[0]);
        return 1; 
    }
    
    char* keyword;
    bool recursive = false;
    if (argc == 2) {
        keyword = argv[1];
    } else {
        recursive = true; 
        keyword = argv[2];
    }
    DIR* dr = opendir(".");
    iterate(dr, keyword, recursive, ".");
    return 0;
}
