#include "pool.h"
#include "pthread.h"
#include <deque>
#include <map>

pthread_mutex_t lock;
pthread_cond_t space_ready;
std::deque<Task*> thread_pool;
std::map<std::string, Task*> threads_info;
int numThreads;


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
<<<<<<< HEAD
    tasks_mutex = PTHREAD_MUTEX_INITIALIZER;
    pool_mutex = PTHREAD_MUTEX_INITIALIZER;
    task_ready = PTHREAD_COND_INITIALIZER;

    thread_pool = std::vector<pthread_t>(num_threads);

    pthread_mutex_lock(&pool_mutex);
    for (int i = 0; i < num_threads; i++) {
        thread_pool[i] = pthread_create(&thread_pool[i], NULL, TaskLoop, (void *)this);
    }
    pthread_mutex_unlock(&pool_mutex);

=======
    numThreads = num_threads;
    pthread_t allThreads[num_threads];
    for(int t = 0; t < num_threads; t++) {
        // create threads via pthread_create()
    }
>>>>>>> 7a956b46dff3d46fe026875c5e8fc7cd5bbfae09
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
