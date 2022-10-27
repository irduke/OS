#ifndef POOL_H_
#include <string>
#include <pthread.h>
#include <deque>
#include <vector>
#include <map>
#include <iostream>

class Task {
public:
    Task();
    virtual ~Task();

    pthread_mutex_t task_lock;
    pthread_cond_t task_cv;
    bool finished;

    virtual void Run() = 0;  // implemented by subclass
};

class ThreadPool {
public:
    std::deque<Task*> tasks;
    std::vector<pthread_t> thread_pool;
    std::map<std::string, Task*> task_map;
    pthread_mutex_t tasks_mutex;
    pthread_mutex_t pool_mutex;
    pthread_mutex_t map_mutex;
    pthread_cond_t task_ready;
    bool shutdown;

    ThreadPool(int num_threads);

    // Submit a task with a particular name.
    void SubmitTask(const std::string &name, Task *task);
 
    // Wait for a task by name, if it hasn't been waited for yet. Only returns after the task is completed.
    void WaitForTask(const std::string &name);

    // Stop all threads. All tasks must have been waited for before calling this.
    // You may assume that SubmitTask() is not caled after this is called.
    void Stop();

};

void* TaskLoop(void * args);

#endif
