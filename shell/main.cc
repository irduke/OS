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
    const char * args[MAX_NUM_TOKENS];
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

    if (DEBUG) {
        std::cout << "Tokens: ";
        std::queue<std::string> t_cpy = tokens;
        while (!t_cpy.empty()) {
            std::cout << t_cpy.front() << " ";
            t_cpy.pop();
        }
        std::cout << std::endl;
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
            curr_command.args[curr_command.arg_index] = tokens.front().c_str();
            curr_command.arg_index++;
            token_counter++;
            tokens.pop();
        }
        curr_command.args[curr_command.arg_index] = NULL;
        command_queue.push(curr_command);
    }

    if (DEBUG) {
        std::queue<cmd> cmd_cpy = command_queue;
        while (!cmd_cpy.empty()) {
            std::cout << "Command: ";
            cmd front = cmd_cpy.front();
            std::cout << "num_args=" << front.arg_index << " " << front.func << " ";
            for (int i = 0; i <= front.arg_index; i++) {
                std::cout << front.args[i] << " ";
            }
            cmd_cpy.pop();
            std::cout << std::endl;
        }
    }


    while (!command_queue.empty()) {
        int status = 0;
        cmd run_command = command_queue.front();
        command_queue.pop();

        pid_t pid = fork();
        if(pid == 0) {
            //Child
            execvp(run_command.func, (char **) run_command.args);
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
    memset(command->args, '\0' , sizeof(command->args));
    command->redirect = false;
    command->arg_index = 0;
}
