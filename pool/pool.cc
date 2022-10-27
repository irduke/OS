#include "pool.h"


void * TaskLoop(void * args) {
    return;
}

Task::Task() {
    task_lock = PTHREAD_MUTEX_INITIALIZER;
    task_cv = PTHREAD_COND_INITIALIZER;
}

Task::~Task() {
    pthread_mutex_destroy(&task_lock);
    pthread_cond_destroy(&task_cv);
}

ThreadPool::ThreadPool(int num_threads) {
    tasks_mutex = PTHREAD_MUTEX_INITIALIZER;
    pool_mutex = PTHREAD_MUTEX_INITIALIZER;
    task_ready = PTHREAD_COND_INITIALIZER;

    thread_pool = std::vector<pthread_t>(num_threads);

    pthread_mutex_lock(&pool_mutex);
    for (int i = 0; i < num_threads; i++) {
        thread_pool[i] = pthread_create(&thread_pool[i], NULL, TaskLoop, (void *)this);
    }
    pthread_mutex_unlock(&pool_mutex);

}

void ThreadPool::SubmitTask(const std::string &name, Task* task) {
}

void ThreadPool::WaitForTask(const std::string &name) {
}

void ThreadPool::Stop() {
}
