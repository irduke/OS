#ifndef POOL_H_
#include <string>
#include <pthread.h>
#include <deque>
#include <vector>
#include <map>
#include <semaphore.h>
#include <set>

class Task {
public:
    Task();
    virtual ~Task();

    // pthread_mutex_t task_lock;
    // pthread_cond_t task_cv;
    // bool finished;

    virtual void Run() = 0;  // implemented by subclass
};

class ThreadPool {
public:
    std::deque<std::pair<std::string, Task*>> tasks;
    std::vector<pthread_t> thread_pool;
    std::set<std::string> completed_tasks;

    pthread_mutex_t complete_tasks_mutex;
    pthread_mutex_t tasks_mutex;
    pthread_mutex_t pool_mutex;
    pthread_cond_t task_done;
    sem_t task_ready_sem;
    bool shutdown;

    ThreadPool(int num_threads);

    // Submit a task with a particular name.
    void SubmitTask(const std::string &name, Task *task);
 
    // Wait for a task by name, if it hasn't been waited for yet. Only returns after the task is completed.
    void WaitForTask(const std::string &name);

    // Stop all threads. All tasks must have been waited for before calling this.
    // You may assume that SubmitTask() is not called after this is called.
    void Stop();

};

void* TaskLoop(void * args);

#endif
