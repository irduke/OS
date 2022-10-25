#include "pool.h"
#include "pthread.h"
#include <deque>
#include <map>

pthread_mutex_t lock;
pthread_cond_t space_ready;
std::deque<Task*> thread_pool;
std::map<std::string, Task*> threads_info;
int numThreads;

Task::Task() {
}

Task::~Task() {
}

ThreadPool::ThreadPool(int num_threads) {
    numThreads = num_threads;
    pthread_t allThreads[num_threads];
    for(int t = 0; t < num_threads; t++) {
        // create threads via pthread_create()
    }
}

void ThreadPool::SubmitTask(const std::string &name, Task* task) {
    pthread_mutex_lock(&lock);
    while(thread_pool.size() >= numThreads) {    // buffer.full()
        pthread_cond_wait(&space_ready, &lock);
    }
    thread_pool.push_back(threads_info[name]);
    pthread_mutex_unlock(&lock);
}

void ThreadPool::WaitForTask(const std::string &name) {
}

void ThreadPool::Stop() {
}
