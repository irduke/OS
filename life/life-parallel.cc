#include "life.h"
#include <pthread.h>

void simulate_life_byThread(LifeBoard &state, int xT, int yT, int a, int b, int steps);
pthread_barrier_t barrier;

void simulate_life_parallel(int threads, LifeBoard &state, int steps) {
    /* YOUR CODE HERE */
    
    int width = state.width();
    int totalNumCells = (state.width()-1)*(state.height()-1);
    int cell_cnt = totalNumCells/threads;

    int a = cell_cnt % width;
    int b = a / width;

    pthread_t allThreads[threads];
    pthread_barrier_init(&barrier, NULL, threads);
    for(int t = 0; t < threads; t++) {
        if(t == 0) {
            // startX = 1, startY = 1. endX = (1+a), endY = (1+b)
            pthread_create(&allThreads[t], NULL, simulate_life_byThread, NULL);
        }   
        // else... startX = a+1, starty = b+1, endX = (a+1)+a, endY = (b+1)+b
    }
    for(int t = 0; t < threads; t++) {
        pthread_join(allThreads[t], NULL);
    }

    pthread_barrier_destroy(&barrier);

}

void simulate_life_byThread(LifeBoard &state, int startX, int startY, int endX, int endY, int steps) {
    LifeBoard next_state{state.width(), state.height()};
    for (int step = 0; step < steps; ++step) {
        /* We use the range [1, width - 1) here instead of
         * [0, width) because we fix the edges to be all 0s.
         */
        for (int y = startY; y < endY; ++y) {
            for (int x = startX; x < endY; ++x) {
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
        pthread_barrier_wait(&barrier);
        swap(state, next_state);
        pthread_barrier_wait(&barrier);
    }
}
