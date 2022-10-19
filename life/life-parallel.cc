#include "life.h"
#include <pthread.h>

#define THREAD_MAX 100

struct life_args {
    LifeBoard* state;
    LifeBoard* next_state;
    pthread_barrier_t* barr;
    int steps;
    int startX;
    int startY;
    int endX;
    int endY;
};

void* simulate_life_byThread(void* args);

void simulate_life_parallel(int threads, LifeBoard &state, int steps) {
    /* YOUR CODE HERE */
    pthread_barrier_t barrier;
    LifeBoard next_state{state.width(), state.height()};
    
    int width = state.width() -2;
    //int height = state.height() -2;
    int totalNumCells = (state.width()-1)*(state.height()-1);
    int cell_cnt = totalNumCells/threads;

    // int a = cell_cnt % width;
    // int b = a / width;
    int a = 0;
    int b = 0;
    

    pthread_t allThreads[THREAD_MAX];
    struct life_args arguments[THREAD_MAX];

    pthread_barrier_init(&barrier, NULL, threads);

    for(int t = 0; t < threads; t++) {
        a += cell_cnt;
        b += a/width;
        a %= width;
        if(t == 0) {
            arguments[t].startX = 1;
            arguments[t].startY = 1;
            arguments[t].endX = 1+a;
            arguments[t].endY = 1+b;
            arguments[t].steps = steps;
            arguments[t].barr = &barrier;
            // startX = 1, startY = 1. endX = (1+a), endY = (1+b)
            pthread_create(&allThreads[t], NULL, simulate_life_byThread, (void*) &arguments[t]);
        }   
        // else... startX = a+1, starty = b+1, endX = (a+1)+a, endY = (b+1)+b
        else {
            arguments[t].startX = a+1;
            arguments[t].startY = b+1;
            arguments[t].endX = (a+1)+a;
            arguments[t].endY = (b+1)+b;
            arguments[t].steps = steps;
            arguments[t].barr = &barrier;
            pthread_create(&allThreads[t], NULL, simulate_life_byThread, (void*) &arguments[t]);
        }
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
    int startX = thread_args->startX;
    int startY = thread_args->startY;
    int endX = thread_args->endX;
    int endY = thread_args->endY;
    pthread_barrier_t* barrier = thread_args->barr;
    LifeBoard* state = thread_args->state;
    LifeBoard* next_state = thread_args->next_state;

    for (int step = 0; step < steps; ++step) {
        /* We use the range [1, width - 1) here instead of
         * [0, width) because we fix the edges to be all 0s.
         */
        for (int y = startY; y < endY; ++y) {
            for (int x = startX; x < endX; ++x) {
                int live_in_window = 0;
                /* For each cell, examine a 3x3 "window" of cells around it,
                 * and count the number of live (true) cells in the window. */
                for (int y_offset = -1; y_offset <= 1; ++y_offset) {
                    for (int x_offset = -1; x_offset <= 1; ++x_offset) {
                        if (state->at(x + x_offset, y + y_offset)) {
                            ++live_in_window;
                        }
                    }
                }
                /* Cells with 3 live neighbors remain or become live.
                   Live cells with 2 live neighbors remain live. */
                next_state->at(x, y) = (
                    live_in_window == 3 /* dead cell with 3 neighbors or live cell with 2 */ ||
                    (live_in_window == 4 && state->at(x, y)) /* live cell with 3 neighbors */
                );
            }
        }
        
        /* now that we computed next_state, make it the current state */
        pthread_barrier_wait(barrier);
        swap(*state, *next_state);
        pthread_barrier_wait(barrier);
    }
    return NULL;
}
