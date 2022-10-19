#include "life.h"
#include <pthread.h>

#define THREAD_MAX 100

struct life_args {
    LifeBoard state;
    LifeBoard next_state;
    pthread_barrier_t* barr;
    int threadId;
    int numThreads;
    int steps;
};

void* simulate_life_byThread(void* args);

void simulate_life_parallel(int threads, LifeBoard &state, int steps) {
    /* YOUR CODE HERE */
    pthread_barrier_t barrier;
    LifeBoard next_state{state.width(), state.height()};
    
    pthread_t allThreads[THREAD_MAX];
    struct life_args arguments[THREAD_MAX];

    pthread_barrier_init(&barrier, NULL, threads);

    for(int t = 0; t < threads; t++) {
        arguments[t].threadId = t;
        arguments[t].numThreads = threads;
        arguments[t].steps = steps;
        arguments[t].barr = &barrier;
        arguments[t].state = state;
        arguments[t].next_state = next_state;
        pthread_create(&allThreads[t], NULL, simulate_life_byThread, (void*) &arguments[t]);
    }
    for(int t = 0; t < threads; t++) {
        pthread_join(allThreads[t], NULL);
    }

    pthread_barrier_destroy(&barrier);
    
}

void* simulate_life_byThread(void* args) {
    //Recast void* into arg struct pointer
    struct life_args * thread_args = (struct life_args *) args;
    int steps = thread_args->steps;
    int threadId = thread_args->threadId;
    int numThreads = thread_args->numThreads;
    pthread_barrier_t* barrier = thread_args->barr;
    LifeBoard state = thread_args->state;
    LifeBoard next_state = thread_args->next_state;

    for (int step = 0; step < steps; ++step) {
        /* We use the range [1, width - 1) here instead of
         * [0, width) because we fix the edges to be all 0s.
         */
        for (int y = threadId + 1; y < state.height()-1; y+=numThreads) {
            for (int x = 1; x < state.width()-1; ++x) {
                int live_in_window = 0;
                /* For each cell, examine a 3x3 "window" of cells around it,
                 * and count the number of live (true) cells in the window. */
                for (int y_offset = -1; y_offset <= 1; ++y_offset) {
                    for (int x_offset = -1; x_offset <= 1; ++x_offset) {
                        if (state.at(x + x_offset, y + y_offset)) {
                            ++live_in_window;
                        }
                    }
                }
                /* Cells with 3 live neighbors remain or become live.
                   Live cells with 2 live neighbors remain live. */
                next_state.at(x, y) = (
                    live_in_window == 3 /* dead cell with 3 neighbors or live cell with 2 */ ||
                    (live_in_window == 4 && state.at(x, y)) /* live cell with 3 neighbors */
                );
            }
        }
        
        /* now that we computed next_state, make it the current state */
        pthread_barrier_wait(barrier);
        if(threadId+1 == numThreads) { // only need to swap once (last thread)
            swap(state, next_state);
        } 
        pthread_barrier_wait(barrier);
    }
    return NULL;
}
