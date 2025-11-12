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
#define ALPHABET_SIZE 256

// Global variables for progress indicator
int processed_entries = 0;

// Simple dynamic array to store matched results for deferred printing
typedef struct {
    char **items;
    size_t size;
    size_t capacity;
} ResultList;

// Boyer-Moore preprocessing tables
typedef struct {
    int bad_char[ALPHABET_SIZE];
    int *good_suffix;
    int *border;
    size_t pattern_len;
} BMSearch;

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

// Preprocess bad character table for Boyer-Moore
static void bm_preprocess_bad_char(const char *pattern, size_t pattern_len, int bad_char[]) {
    for (int i = 0; i < ALPHABET_SIZE; i++) {
        bad_char[i] = pattern_len;
    }
    
    for (size_t i = 0; i < pattern_len - 1; i++) {
        unsigned char c = tolower((unsigned char)pattern[i]);
        bad_char[c] = pattern_len - 1 - i;
    }
}

// Preprocess good suffix table for Boyer-Moore
static void bm_preprocess_good_suffix(const char *pattern, size_t pattern_len, 
                                      int good_suffix[], int border[]) {
    int i = pattern_len;
    int j = pattern_len + 1;
    border[i] = j;
    
    while (i > 0) {
        while (j <= (int)pattern_len && 
               tolower((unsigned char)pattern[i - 1]) != tolower((unsigned char)pattern[j - 1])) {
            if (good_suffix[j] == 0) {
                good_suffix[j] = j - i;
            }
            j = border[j];
        }
        i--;
        j--;
        border[i] = j;
    }
    
    j = border[0];
    for (i = 0; i <= (int)pattern_len; i++) {
        if (good_suffix[i] == 0) {
            good_suffix[i] = j;
        }
        if (i == j) {
            j = border[j];
        }
    }
}

// Initialize Boyer-Moore search structure
static BMSearch* bm_init(const char *pattern) {
    BMSearch *bm = (BMSearch*)malloc(sizeof(BMSearch));
    if (!bm) return NULL;
    
    bm->pattern_len = strlen(pattern);
    bm->good_suffix = (int*)calloc(bm->pattern_len + 1, sizeof(int));
    bm->border = (int*)calloc(bm->pattern_len + 1, sizeof(int));
    
    if (!bm->good_suffix || !bm->border) {
        free(bm->good_suffix);
        free(bm->border);
        free(bm);
        return NULL;
    }
    
    bm_preprocess_bad_char(pattern, bm->pattern_len, bm->bad_char);
    bm_preprocess_good_suffix(pattern, bm->pattern_len, bm->good_suffix, bm->border);
    
    return bm;
}

// Free Boyer-Moore search structure
static void bm_free(BMSearch *bm) {
    if (bm) {
        free(bm->good_suffix);
        free(bm->border);
        free(bm);
    }
}

// Boyer-Moore case-insensitive search
static const char* bm_search(const char *text, const char *pattern, BMSearch *bm) {
    size_t text_len = strlen(text);
    size_t pattern_len = bm->pattern_len;
    
    if (pattern_len == 0) return text;
    if (text_len < pattern_len) return NULL;
    
    int i = pattern_len - 1;
    while (i < (int)text_len) {
        int k = i;
        int j = pattern_len - 1;
        
        while (j >= 0 && tolower((unsigned char)text[k]) == tolower((unsigned char)pattern[j])) {
            k--;
            j--;
        }
        
        if (j < 0) {
            return &text[i - pattern_len + 1];
        }
        
    int bad_char_shift = bm->bad_char[(unsigned char)tolower((unsigned char)text[k])];
        int good_suffix_shift = bm->good_suffix[j + 1];
        i += (bad_char_shift > good_suffix_shift) ? bad_char_shift : good_suffix_shift;
    }
    
    return NULL;
}

void print_with_highlight(const char* str, const char* keyword, BMSearch *bm) {
    const char* current_pos = str;
    size_t keyword_len = bm->pattern_len;
    const char* found_pos;

    while (1) {
        found_pos = bm_search(current_pos, keyword, bm);

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
 * Case-insensitive substring search using Boyer-Moore
 */
bool contains_keyword_case_insensitive(const char* str, const char* keyword, BMSearch *bm) {
    return bm_search(str, keyword, bm) != NULL;
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
int iterate(DIR* dr, const char* keyword, bool recursive, const char* prefix, ResultList *results, BMSearch *bm) {
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
        if (contains_keyword_case_insensitive(fileName, keyword, bm)) {
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
                    iterate(subdr, keyword, recursive, fullpath, results, bm);
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
    
    if (keyword[0] == '\0') {
        fprintf(stderr, "Error: keyword must be non-empty\n");
        return 1;
    }

    BMSearch *bm = bm_init(keyword);
    if (!bm) {
        fprintf(stderr, "Error: failed to initialize search structures\n");
        return 1;
    }

    DIR* dr = opendir(".");
    if (dr == NULL) {
        fprintf(stderr, "Error: Could not open current directory\n");
        bm_free(bm);
        return 1;
    }
    
    ResultList results;
    results_init(&results);
    
    int result = iterate(dr, keyword, recursive, ".", &results, bm);
    closedir(dr);
    
    fprintf(stderr, "\n"); // Newline after progress indicator
    
    // Sort results to provide deterministic output order
    if (results.size > 1) {
        qsort(results.items, results.size, sizeof(char *), compare_results);
    }

    // Print all results after scanning completes
    for (size_t i = 0; i < results.size; ++i) {
        print_with_highlight(results.items[i], keyword, bm);
    }
    results_free(&results);
    bm_free(bm);
    
    return result;
}
