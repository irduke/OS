#include "pool.h"

void* TaskLoop(void * args) {
    ThreadPool * tp = (ThreadPool *)args;
    std::string task_name;
    Task* task;

    while (!(tp->shutdown)) {
        sem_wait(&tp->task_ready_sem);
        if (tp->shutdown) break;

        //pop from deque
        pthread_mutex_lock(&tp->tasks_mutex);
        task_name = tp->tasks.front().first;
        task = tp->tasks.front().second;
        tp->tasks.pop_front();
        pthread_mutex_unlock(&tp->tasks_mutex);

        //Run the task
        task->Run();

        //Once completed add task to completed set and signal that it is done, then delete
        pthread_mutex_lock(&tp->complete_tasks_mutex);
        tp->completed_tasks.insert(task_name);
        pthread_mutex_unlock(&tp->complete_tasks_mutex);
        pthread_cond_broadcast(&tp->task_done);
        delete task;
    }
    return NULL;
}

Task::Task() {

}

Task::~Task() {

}

ThreadPool::ThreadPool(int num_threads) {
    tasks_mutex = PTHREAD_MUTEX_INITIALIZER;
    pool_mutex = PTHREAD_MUTEX_INITIALIZER;
    complete_tasks_mutex = PTHREAD_MUTEX_INITIALIZER;
    task_done = PTHREAD_COND_INITIALIZER;
    sem_init(&task_ready_sem, 0, 0);
    
    thread_pool = std::vector<pthread_t>(num_threads);

    shutdown = false;

    pthread_mutex_lock(&pool_mutex);
    for (int i = 0; i < num_threads; i++) {
        pthread_create(&thread_pool[i], NULL, TaskLoop, (void *)this);
    }
    pthread_mutex_unlock(&pool_mutex);
}

void ThreadPool::SubmitTask(const std::string &name, Task* task) {
    //Add task to queue
    pthread_mutex_lock(&tasks_mutex);
    tasks.push_back({name, task});
    pthread_mutex_unlock(&tasks_mutex);
    //Alert threads there is a task ready
    sem_post(&task_ready_sem);

}

void ThreadPool::WaitForTask(const std::string &name) {
    pthread_mutex_lock(&complete_tasks_mutex);
    while(completed_tasks.count(name) == 0) {
        pthread_cond_wait(&task_done, &complete_tasks_mutex);
    }
    //exits when cv is signaled and task is done, delete entry in set
    completed_tasks.erase(name);
    pthread_mutex_unlock(&complete_tasks_mutex);
}

void ThreadPool::Stop() {
    shutdown = true;

    pthread_mutex_lock(&pool_mutex);
    for (size_t i = 0; i < thread_pool.size(); i++) {
        sem_post(&task_ready_sem);
    }
    for (size_t i = 0; i < thread_pool.size(); i++) {
        pthread_join(thread_pool[i], NULL);
    }
    pthread_mutex_unlock(&pool_mutex);
    //cleanup
    thread_pool.clear();
    tasks.clear();
    completed_tasks.clear();
    pthread_mutex_destroy(&tasks_mutex);
    pthread_mutex_destroy(&pool_mutex);
    pthread_mutex_destroy(&complete_tasks_mutex);
    pthread_cond_destroy(&task_done);
    sem_destroy(&task_ready_sem);
}
