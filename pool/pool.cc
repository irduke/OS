#include "pool.h"

void * TaskLoop(void * args) {
    ThreadPool * tp = (ThreadPool *)args;
    Task* task;

    while (!(tp->shutdown)) {
        //From here to the ******** I'm very unsure, not sure which lock to use for the CV
        pthread_mutex_lock(&tp->tasks_mutex);
        while (!(tp->tasks.empty())) {
            pthread_cond_wait(&tp->task_ready, &tp->tasks_mutex);
        }
        //pop from deque and unlock mutex
        task = tp->tasks.front();
        tp->tasks.pop_front();
        pthread_mutex_unlock(&tp->tasks_mutex);
        /***********************/

        //Run the task
        task->Run();
        task->finished = true;
        pthread_cond_signal(&task->task_cv);
    }

    return NULL;
}

Task::Task() {
    task_lock = PTHREAD_MUTEX_INITIALIZER;
    task_cv = PTHREAD_COND_INITIALIZER;
    finished = false;
}

Task::~Task() {
    pthread_cond_destroy(&task_cv);
    pthread_mutex_destroy(&task_lock);
}

ThreadPool::ThreadPool(int num_threads) {
    tasks_mutex = PTHREAD_MUTEX_INITIALIZER;
    pool_mutex = PTHREAD_MUTEX_INITIALIZER;
    task_ready = PTHREAD_COND_INITIALIZER;

    thread_pool = std::vector<pthread_t>(num_threads);

    shutdown = false;

    pthread_mutex_lock(&pool_mutex);
    for (int i = 0; i < num_threads; i++) {
        thread_pool[i] = pthread_create(&thread_pool[i], NULL, TaskLoop, (void *)this);
    }
    pthread_mutex_unlock(&pool_mutex);
}

void ThreadPool::SubmitTask(const std::string &name, Task* task) {
    if (task_map.count(name)) {
        perror("Task already in queue\n");
        exit(1);
    }
    else {
        //Add task to queue
        pthread_mutex_lock(&tasks_mutex);
        tasks.push_back(task);
        pthread_mutex_unlock(&tasks_mutex);
        
        //Lock map
        pthread_mutex_lock(&map_mutex);
        task_map.insert({name, task});
        //Alert threads there is a task ready
        pthread_cond_broadcast(&task_ready);
        //Release lock
        pthread_mutex_unlock(&map_mutex);
    }
}

void ThreadPool::WaitForTask(const std::string &name) {
    Task * waiting_task = task_map.at(name);
    pthread_mutex_lock(&waiting_task->task_lock);
    while (!waiting_task->finished) {
        pthread_cond_wait(&waiting_task->task_cv, &waiting_task->task_lock);
    }
    //Task is completed, lock map and delete entry
    pthread_mutex_unlock(&waiting_task->task_lock);
    pthread_mutex_destroy(&waiting_task->task_lock);
    pthread_cond_destroy(&waiting_task->task_cv);
    pthread_mutex_lock(&map_mutex);
    task_map.erase(name);
    pthread_mutex_unlock(&map_mutex);
}

void ThreadPool::Stop() {
    shutdown = true;
    pthread_mutex_lock(&map_mutex);
    std::map<std::string, Task*>::iterator it;
    for (it = task_map.begin(); it != task_map.end(); it++) {
        Task* currtask = it->second;
        pthread_mutex_lock(&currtask->task_lock);
        pthread_cond_destroy(&currtask->task_cv);
        pthread_mutex_unlock(&currtask->task_lock);
        pthread_mutex_destroy(&currtask->task_lock);
    }
    task_map.clear();
    pthread_mutex_unlock(&map_mutex);
}
