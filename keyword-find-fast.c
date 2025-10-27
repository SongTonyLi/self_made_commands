#include <stdio.h>
#include <dirent.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <pthread.h>
#include <errno.h>

#define MAX_PATH_LENGTH 4096

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

/* Simple linked-list queue for directory paths */
typedef struct QNode {
    char* path;
    struct QNode* next;
} QNode;

typedef struct {
    const char* keyword;
    bool recursive;

    /* Work queue */
    pthread_mutex_t queue_mtx;
    pthread_cond_t  queue_cv;
    QNode* q_head;
    QNode* q_tail;
    size_t outstanding; /* Number of directories not yet fully processed */

    /* Results */
    pthread_mutex_t results_mtx;
    char** results;
    size_t results_len;
    size_t results_cap;

    /* Progress tracking */
    pthread_mutex_t progress_mtx;
    size_t dirs_processed;
    size_t dirs_total;
} Shared;

/* Add a result path (thread-safe) */
static void results_add(Shared* s, const char* path) {
    pthread_mutex_lock(&s->results_mtx);
    if (s->results_len == s->results_cap) {
        size_t new_cap = s->results_cap ? s->results_cap * 2 : 1024;
        char** new_arr = (char**)realloc(s->results, new_cap * sizeof(char*));
        if (!new_arr) {
            pthread_mutex_unlock(&s->results_mtx);
            fprintf(stderr, "Error: Out of memory while growing results array\n");
            return;
        }
        s->results = new_arr;
        s->results_cap = new_cap;
    }
    char* dup = strdup(path);
    if (!dup) {
        pthread_mutex_unlock(&s->results_mtx);
        fprintf(stderr, "Error: Out of memory duplicating result path\n");
        return;
    }
    s->results[s->results_len++] = dup;
    pthread_mutex_unlock(&s->results_mtx);
}

/* Enqueue a directory path; caller must hold queue_mtx */
static void enqueue_dir_locked(Shared* s, char* path_dup) {
    QNode* n = (QNode*)malloc(sizeof(QNode));
    if (!n) {
        fprintf(stderr, "Error: Out of memory allocating queue node\n");
        free(path_dup);
        return;
    }
    n->path = path_dup;
    n->next = NULL;
    if (s->q_tail) {
        s->q_tail->next = n;
    } else {
        s->q_head = n;
    }
    s->q_tail = n;
    s->outstanding++;
    
    /* Update total directory count */
    pthread_mutex_lock(&s->progress_mtx);
    s->dirs_total++;
    pthread_mutex_unlock(&s->progress_mtx);
    
    pthread_cond_signal(&s->queue_cv);
}

/* Worker thread */
static void* worker_thread(void* arg) {
    Shared* s = (Shared*)arg;

    for (;;) {
        /* Dequeue a directory to process */
        pthread_mutex_lock(&s->queue_mtx);
        while (s->q_head == NULL && s->outstanding > 0) {
            pthread_cond_wait(&s->queue_cv, &s->queue_mtx);
        }
        if (s->outstanding == 0) {
            pthread_mutex_unlock(&s->queue_mtx);
            return NULL; /* No more work */
        }
        QNode* node = s->q_head;
        s->q_head = node->next;
        if (s->q_head == NULL) s->q_tail = NULL;
        pthread_mutex_unlock(&s->queue_mtx);

        char* dirpath = node->path;
        free(node);

        DIR* dr = opendir(dirpath);
        if (dr == NULL) {
            fprintf(stderr, "Warning: Could not open directory: %s\n", dirpath);
            /* Mark this directory as done */
            pthread_mutex_lock(&s->queue_mtx);
            if (s->outstanding > 0) s->outstanding--;
            if (s->outstanding == 0) pthread_cond_broadcast(&s->queue_cv);
            pthread_mutex_unlock(&s->queue_mtx);
            free(dirpath);
            continue;
        }

        struct dirent* de;
        while ((de = readdir(dr)) != NULL) {
            const char* fileName = de->d_name;

            /* Skip . and .. */
            if (strcmp(fileName, ".") == 0 || strcmp(fileName, "..") == 0) continue;

            char fullpath[MAX_PATH_LENGTH];
            size_t path_len = (size_t)snprintf(fullpath, sizeof(fullpath), "%s/%s", dirpath, fileName);
            if (path_len >= sizeof(fullpath)) {
                fprintf(stderr, "Warning: Path too long, skipping: %s/%s\n", dirpath, fileName);
                continue;
            }

            /* Check if this is a directory for potential recursion */
            struct stat st;
            bool is_dir = false;
            if (lstat(fullpath, &st) == 0 && S_ISDIR(st.st_mode) && !S_ISLNK(st.st_mode)) {
                is_dir = true;
            }

            /* Add to results if filename contains keyword */
            if (contains_keyword_case_insensitive(fileName, s->keyword)) {
                results_add(s, fullpath);
            }

            /* Recurse into subdirectories if requested */
            if (s->recursive && is_dir) {
                char* dup = strdup(fullpath);
                if (!dup) {
                    fprintf(stderr, "Error: Out of memory duplicating path\n");
                } else {
                    pthread_mutex_lock(&s->queue_mtx);
                    enqueue_dir_locked(s, dup);
                    pthread_mutex_unlock(&s->queue_mtx);
                }
            }
        }

        closedir(dr);

        /* Mark this directory as done and update progress */
        pthread_mutex_lock(&s->queue_mtx);
        if (s->outstanding > 0) s->outstanding--;
        if (s->outstanding == 0) pthread_cond_broadcast(&s->queue_cv);
        pthread_mutex_unlock(&s->queue_mtx);
        
        pthread_mutex_lock(&s->progress_mtx);
        s->dirs_processed++;
        pthread_mutex_unlock(&s->progress_mtx);

        free(dirpath);
    }
    /* Unreachable */
    return NULL;
}

static int cmp_paths(const void* a, const void* b) {
    const char* const* pa = (const char* const*)a;
    const char* const* pb = (const char* const*)b;
    return strcmp(*pa, *pb);
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

/* Progress display thread --------------------------------------------------*/
static void* progress_thread(void* arg) {
    Shared* s = (Shared*)arg;

    while (1) {
        /* ------------------------------------------------------------------*/
        /* 1. Read the shared state.  We lock the two mutexes separately
           because the critical sections are tiny and we want to minimise
           contention with the worker threads. */
        /* ------------------------------------------------------------------*/
        pthread_mutex_lock(&s->queue_mtx);
        size_t outstanding = s->outstanding;   /* dirs still being processed */
        pthread_mutex_unlock(&s->queue_mtx);

        /* If there is no work left, break out of the loop – we will print
           the final bar after the loop. */
        if (outstanding == 0)
            break;

        pthread_mutex_lock(&s->progress_mtx);
        size_t processed = s->dirs_processed;
        size_t total     = s->dirs_total;
        pthread_mutex_unlock(&s->progress_mtx);

        pthread_mutex_lock(&s->results_mtx);
        size_t found = s->results_len;
        pthread_mutex_unlock(&s->results_mtx);

        /* ------------------------------------------------------------------*/
        /* 2. Render the progress bar for the *current* state.                */
        /* ------------------------------------------------------------------*/
        int bar_width = 30;
        float percentage = total > 0 ? (float)processed / total : 0.0f;
        int filled = (int)(percentage * bar_width);

        fprintf(stderr, "\r\033[KScanning: [");
        for (int i = 0; i < bar_width; i++) {
            if (i < filled)          fprintf(stderr, "=");
            else if (i == filled)    fprintf(stderr, ">");
            else                     fprintf(stderr, " ");
        }
        fprintf(stderr, "] %zu/%zu dirs | Found %zu matches",
                processed, total, found);
        fflush(stderr);

        /* Update at roughly 20 Hz – plenty of responsiveness without
           busy‑spinning. */
        usleep(50000);
    }

    /* ----------------------------------------------------------------------*/
    /* 3. Final bar – this will always be 100 % and display the final
       number of matches.                                                 */
    /* ----------------------------------------------------------------------*/
    pthread_mutex_lock(&s->queue_mtx);
    size_t outstanding_final = s->outstanding;   /* should be 0 here */
    pthread_mutex_unlock(&s->queue_mtx);

    pthread_mutex_lock(&s->progress_mtx);
    size_t processed_final = s->dirs_processed;
    size_t total_final     = s->dirs_total;
    pthread_mutex_unlock(&s->progress_mtx);

    pthread_mutex_lock(&s->results_mtx);
    size_t found_final = s->results_len;
    pthread_mutex_unlock(&s->results_mtx);

    int bar_width = 30;
    /* 100 % full bar */
    fprintf(stderr, "\r\033[KScanning: [");
    for (int i = 0; i < bar_width; i++) {
        if (i < bar_width - 1) fprintf(stderr, "=");
        else                   fprintf(stderr, ">");
    }
    fprintf(stderr, "] %zu/%zu dirs | Found %zu matches\n",
            processed_final, total_final, found_final);
    fflush(stderr);

    return NULL;
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

    /* Check we can open the current directory early (for error parity) */
    DIR* test = opendir(".");
    if (test == NULL) {
        fprintf(stderr, "Error: Could not open current directory\n");
        return 1;
    }
    closedir(test);

    Shared s;
    s.keyword = keyword;
    s.recursive = recursive;
    s.q_head = s.q_tail = NULL;
    s.outstanding = 0;
    s.results = NULL;
    s.results_len = 0;
    s.results_cap = 0;
    s.dirs_processed = 0;
    s.dirs_total = 0;
    pthread_mutex_init(&s.queue_mtx, NULL);
    pthread_cond_init(&s.queue_cv, NULL);
    pthread_mutex_init(&s.results_mtx, NULL);
    pthread_mutex_init(&s.progress_mtx, NULL);

    /* Enqueue root directory "." */
    pthread_mutex_lock(&s.queue_mtx);
    char* root = strdup(".");
    if (!root) {
        pthread_mutex_unlock(&s.queue_mtx);
        fprintf(stderr, "Error: Out of memory duplicating root path\n");
        pthread_mutex_destroy(&s.queue_mtx);
        pthread_cond_destroy(&s.queue_cv);
        pthread_mutex_destroy(&s.results_mtx);
        pthread_mutex_destroy(&s.progress_mtx);
        return 1;
    }
    enqueue_dir_locked(&s, root);
    pthread_mutex_unlock(&s.queue_mtx);

    /* Determine thread count (use number of online CPUs, fallback to 4) */
    long ncpu = sysconf(_SC_NPROCESSORS_ONLN);
    int thread_count = (ncpu > 0 && ncpu < 256) ? (int)ncpu : 4;

    pthread_t* threads = (pthread_t*)malloc(sizeof(pthread_t) * (size_t)thread_count);
    if (!threads) {
        fprintf(stderr, "Error: Out of memory allocating threads array\n");
        return 1;
    }

    /* Start progress thread */
    pthread_t prog_thread;
    pthread_create(&prog_thread, NULL, progress_thread, &s);

    for (int i = 0; i < thread_count; i++) {
        int rc = pthread_create(&threads[i], NULL, worker_thread, &s);
        if (rc != 0) {
            fprintf(stderr, "Error: Could not create thread %d: %s\n", i, strerror(rc));
            /* Best effort: continue with fewer threads */
            threads[i] = 0;
            break;
        }
    }

    for (int i = 0; i < thread_count; i++) {
        if (threads[i]) pthread_join(threads[i], NULL);
    }
    
    /* Wait for progress thread to finish */
    pthread_join(prog_thread, NULL);
    
    free(threads);

    /* Sort and print results */
    if (s.results_len > 1) {
        qsort(s.results, s.results_len, sizeof(char*), cmp_paths);
    }
    for (size_t i = 0; i < s.results_len; i++) {
        print_with_highlight(s.results[i], s.keyword);
        free(s.results[i]);
    }
    free(s.results);

    pthread_mutex_destroy(&s.queue_mtx);
    pthread_cond_destroy(&s.queue_cv);
    pthread_mutex_destroy(&s.results_mtx);
    pthread_mutex_destroy(&s.progress_mtx);

    return 0;
}
