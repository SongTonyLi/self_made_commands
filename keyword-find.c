#include <stdio.h>
#include <dirent.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_PATH_LENGTH 4096

// Global variables for progress indicator
int processed_entries = 0;

// Simple dynamic array to store matched results for deferred printing
typedef struct {
    char **items;
    size_t size;
    size_t capacity;
} ResultList;

static void results_init(ResultList *r) {
    r->items = NULL;
    r->size = 0;
    r->capacity = 0;
}

static int results_add(ResultList *r, const char *path) {
    if (r->size == r->capacity) {
        size_t newcap = r->capacity ? (r->capacity * 2) : 64;
        char **newitems = (char**)realloc(r->items, newcap * sizeof(char*));
        if (!newitems) return 0;
        r->items = newitems;
        r->capacity = newcap;
    }
    char *copy = strdup(path);
    if (!copy) return 0;
    r->items[r->size++] = copy;
    return 1;
}

static void results_free(ResultList *r) {
    for (size_t i = 0; i < r->size; ++i) {
        free(r->items[i]);
    }
    free(r->items);
    r->items = NULL;
    r->size = 0;
    r->capacity = 0;
}

static int compare_results(const void *a, const void *b) {
    const char *const *sa = (const char *const *)a;
    const char *const *sb = (const char *const *)b;
    return strcmp(*sa, *sb);
}

const char* my_strcasestr(const char* haystack, const char* needle) {
    if (!*needle) {
        return haystack;
    }
    for (; *haystack; ++haystack) {
        if (tolower((unsigned char)*haystack) == tolower((unsigned char)*needle)) {
            const char* h = haystack;
            const char* n = needle;
            for (; *h && *n; ++h, ++n) {
                if (tolower((unsigned char)*h) != tolower((unsigned char)*n)) {
                    break;
                }
            }
            if (!*n) {
                return haystack;
            }
        }
    }
    return NULL;
}

void print_with_highlight(const char* str, const char* keyword) {
    const char* current_pos = str;
    size_t keyword_len = strlen(keyword);
    const char* found_pos;

    while (1) {
        found_pos = my_strcasestr(current_pos, keyword);

        if (found_pos == NULL) {
            printf("%s", current_pos);
            break;
        }

        printf("%.*s", (int)(found_pos - current_pos), current_pos);
        printf("\x1b[31m%.*s\x1b[0m", (int)keyword_len, found_pos);
        current_pos = found_pos + keyword_len;
    }
    printf("\n");
}

/**
 * Print an indeterminate progress spinner with processed count and matches found
 */
void print_progress(size_t matches_found) {
    static const char spinner[] = "|/-\\";
    static int idx = 0;

    fprintf(stderr, "\r%c Scanned %d entries | Found %zu matches", spinner[idx], processed_entries, matches_found);
    fflush(stderr);

    idx = (idx + 1) % 4;
}

 

/**
 * Case-insensitive substring search
 */
bool contains_keyword_case_insensitive(const char* str, const char* keyword) {
    size_t str_len = strlen(str);
    size_t keyword_len = strlen(keyword);
    
    if (keyword_len > str_len) {
        return false;
    }
    
    for (size_t i = 0; i <= str_len - keyword_len; i++) {
        bool match = true;
        for (size_t j = 0; j < keyword_len; j++) {
            if (tolower((unsigned char)str[i + j]) != tolower((unsigned char)keyword[j])) {
                match = false;
                break;
            }
        }
        if (match) {
            return true;
        }
    }
    return false;
}

/**
 * Check if a keyword exists as a substring in a given string (case-sensitive)
 */
bool contains_keyword(const char* str, const char* keyword) {
    return strstr(str, keyword) != NULL;
}

/**
 * Recursively iterate through directory and collect files matching the keyword
 */
int iterate(DIR* dr, const char* keyword, bool recursive, const char* prefix, ResultList *results) {
    struct dirent* de;
    
    if (dr == NULL) {
        fprintf(stderr, "Error: Could not open directory '%s'\n", prefix);
        return 1;
    }

    while ((de = readdir(dr)) != NULL) {
        const char* fileName = de->d_name;
        
        // Skip current and parent directory entries
        if (strcmp(fileName, ".") == 0 || strcmp(fileName, "..") == 0) {
            continue;
        }

        // Update progress after a valid entry is seen
        processed_entries++;
        print_progress(results->size);
        
        // Check if filename contains the keyword and collect result
        if (contains_keyword_case_insensitive(fileName, keyword)) {
            char matchpath[MAX_PATH_LENGTH];
            size_t n = (size_t)snprintf(matchpath, sizeof(matchpath), "%s/%s", prefix, fileName);
            if (n < sizeof(matchpath)) {
                (void)results_add(results, matchpath);
            } else {
                // Path too long; ignore this match to avoid truncation issues
            }
        }
        
        // Handle recursive directory traversal
        if (recursive) {
            char fullpath[MAX_PATH_LENGTH];
            size_t path_len = (size_t)snprintf(fullpath, sizeof(fullpath), "%s/%s", prefix, fileName);
            
            // Check for path length overflow
            if (path_len >= sizeof(fullpath)) {
                fprintf(stderr, "Warning: Path too long, skipping: %s/%s\n", prefix, fileName);
                continue;
            }
            
            struct stat path_stat;
            // Use lstat to avoid following symlinks
            if (lstat(fullpath, &path_stat) == 0 && S_ISDIR(path_stat.st_mode) && !S_ISLNK(path_stat.st_mode)) {
                DIR* subdr = opendir(fullpath);
                if (subdr != NULL) {
                    iterate(subdr, keyword, recursive, fullpath, results);
                    closedir(subdr);
                } else {
                    fprintf(stderr, "Warning: Could not open directory: %s\n", fullpath);
                }
            }
        }
    }
    
    return 0; 
}

int main(int argc, char *argv[]) {
    if (argc < 2 || argc > 3 || (argc == 3 && strcmp(argv[1], "-r") != 0)) {
        fprintf(stderr, "Usage: %s [-r] <keyword>\n", argv[0]);
        fprintf(stderr, "  -r    Recursively search subdirectories\n");
        return 1; 
    }
    
    const char* keyword;
    bool recursive = false;
    
    if (argc == 2) {
        keyword = argv[1];
    } else {
        recursive = true; 
        keyword = argv[2];
    }
    
    DIR* dr = opendir(".");
    if (dr == NULL) {
        fprintf(stderr, "Error: Could not open current directory\n");
        return 1;
    }
    
    ResultList results;
    results_init(&results);
    
    int result = iterate(dr, keyword, recursive, ".", &results);
    closedir(dr);
    
    fprintf(stderr, "\n"); // Newline after progress indicator
    
    // Sort results to provide deterministic output order
    if (results.size > 1) {
        qsort(results.items, results.size, sizeof(char *), compare_results);
    }

    // Print all results after scanning completes
    for (size_t i = 0; i < results.size; ++i) {
        print_with_highlight(results.items[i], keyword);
    }
    results_free(&results);
    
    return result;
}
