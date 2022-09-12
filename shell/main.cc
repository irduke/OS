#include <cstdlib>
#include <iostream>
#include <string>
#include <cstring>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <vector>
#include <sstream>  
#include <queue>
#include <cstdio>
#include <cerrno>
#include <regex>

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

bool is_word(std::string token);

bool is_well_formed(std::vector<char*> command);

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
    std::vector<std::string> tokens;
    std::queue<cmd> command_queue;
    std::string t;

    while(s >> t) {
        tokens.push_back(t);
    }

    std::string curr_token;
    int num_tokens = tokens.size();
    int token_counter = 0;

    while (token_counter < num_tokens) {
        //Create and init command struct
        cmd curr_command;
        init_cmd(&curr_command);
        //Grab function to execute and pop from queue
        curr_token = tokens.at(token_counter);
        if(curr_token == "|") { 
            // if pipe reached, jump to next token
            token_counter++;
        }
        curr_command.func = const_cast<char*>(tokens.at(token_counter).c_str());
        while (token_counter < num_tokens && tokens.at(token_counter) != "|") {
            curr_token = tokens.at(token_counter);
            curr_command.args.push_back(const_cast<char*>(tokens.at(token_counter).c_str()));
            curr_command.arg_index++;
            token_counter++;
        }
        curr_command.args.push_back(NULL);
        command_queue.push(curr_command);
    }

    while (!command_queue.empty()) {
        cmd run_command = command_queue.front();
        command_queue.pop();

        pid_t pid = fork();
        if(pid == 0) {
            //Child
            char **argv = &run_command.args[0];
            execvp(run_command.func, argv);
            perror("execvp");
            exit(errno);
        }
        else if(pid > 0) {
            //Parent process, wait for child
            if(strcmp(run_command.args.at(run_command.args.size()-2), "&") != 0) {
                int status;
                waitpid(pid, &status, 0);
                std::cout << run_command.func << " exit status: " << WEXITSTATUS(status) << std::endl;
            }
        }
        else {
            std::cerr << "Fork" << std::endl;
        }
    }
}

void init_cmd(cmd * command) {
    //memset(command->args, '\0' , sizeof(command->args));
    command->redirect = false;
    command->arg_index = 0;
}

