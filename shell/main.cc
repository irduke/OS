#include <cstdlib>
#include <iostream>
#include <string>
#include <cstring>
#include <string.h>
#include <filesystem>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>
#include <sstream>  
#include <queue>

#define MAX_NUM_TOKENS 50
#define DEBUG false

typedef struct cmd
{
    std::vector<char*> args;
    bool redirect;
    int arg_index;
    const char * func;
} cmd;

void init_cmd(cmd * command);

void parse_and_run_command(const std::string &command);


int main(void) {
    std::string command;
    std::cout << "> ";
    while (std::getline(std::cin, command)) {
        parse_and_run_command(command);
        std::cout << "> ";
    }
    return 0;
}

void parse_and_run_command(const std::string &command) {
    /* TODO: Implement this. */
    /* Note that this is not the correct way to test for the exit command.
       For example the command "   exit  " should also exit your shell.
     */

    if(command == "exit") {
        exit(0);
    }

    std::stringstream s(command);
    std::queue<std::string> tokens;
    std::queue<cmd> command_queue;
    std::string t;

    while(s >> t) {
        tokens.push(t);
    }

    std::string curr_token;
    int num_tokens = tokens.size();
    int token_counter = 0;

    while (!tokens.empty()) {
        //Create and init command struct
        cmd curr_command;
        init_cmd(&curr_command);
        //Grab function to execute and pop from queue
        curr_command.func = tokens.front().c_str();
        tokens.pop();
        while (curr_token != "|" && token_counter < num_tokens - 1) {
            curr_token = tokens.front();
            curr_command.args.push_back(const_cast<char*>(curr_token.c_str()));
            curr_command.arg_index++;
            token_counter++;
            tokens.pop();
        }
        curr_command.args.push_back(NULL);
        command_queue.push(curr_command);
    }

    while (!command_queue.empty()) {
        int status = 0;
        cmd run_command = command_queue.front();
        command_queue.pop();

        pid_t pid = fork();
        if(pid == 0) {
            //Child
            execvp(run_command.func, &run_command.args[0]);
            perror("execvp");
            exit(errno);
        }
        else if(pid > 0) {
            //Parent process, wait for child
            waitpid(pid, &status, 0);
        }
        else {
            std::cerr << "Fork" << std::endl;
        }

        std::cout << run_command.func << " exit status: " << WEXITSTATUS(status) << std::endl;
    }
}

void init_cmd(cmd * command) {
    //memset(command->args, '\0' , sizeof(command->args));
    command->redirect = false;
    command->arg_index = 0;
}
