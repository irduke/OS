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
    int arg_index;
    const char * func;
    const char * redir_out;
    const char * redir_in;
} cmd;

std::ostream& operator<<(std::ostream& os, const cmd& command) {
    size_t i;
    os << "Command args: ";
    for (i=0; i<command.args.size(); i++) {
        os << command.args[i] << " ";
    }
    os << "Redir output: " << command.redir_out << ", ";
    os << "Redir input: " << command.redir_in << ", ";
    return os;
}

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
            if (curr_token == ">") {
                //Skip over redirect token
                token_counter++;
                //set current command output to redirect output
                curr_command.redir_out = const_cast<char*>(tokens.at(token_counter).c_str());
                token_counter++;
            }
            else if (curr_token == "<") {
                //Skip over redirect token
                token_counter++;
                //set current command input to redirect input
                curr_command.redir_in = const_cast<char*>(tokens.at(token_counter).c_str());
                token_counter++;
            }
            else {
                curr_command.args.push_back(const_cast<char*>(tokens.at(token_counter).c_str()));
                curr_command.arg_index++;
                token_counter++;
            }
        }
        if(is_well_formed(curr_command.args)) {
            curr_command.args.push_back(NULL);
            command_queue.push(curr_command);
        }
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
    command->arg_index = 0;
}

bool is_word(std::string token) {
    // Uses regex to check if a string is alphabetical
    return std::regex_match(token, std::regex("^[A-Za-z/]+$"));
}

bool is_well_formed(std::vector<char*> command) {
    /*
    Checks that each command meets the following conditions...
    1) No more than one input redirection
    2) No more than one output redirection
    3) At least one or more words
    */
    bool is_well_formed = true;
    int num_input_redirect = 0;
    int num_output_redirect = 0;
    int num_words = 0;    

    for(size_t i = 0; i < command.size(); i++) {
        if(i < command.size()-1) {
            // verify redirect character & word token combination
            if((strcmp(command.at(i), "<") == 0) && is_word(command.at(i+1))) num_input_redirect++;
            else if((strcmp(command.at(i), ">") == 0) && is_word(command.at(i+1))) num_output_redirect++;
        }
        if(is_word(command.at(i))) num_words++;
    }

    if(num_input_redirect > 1 || num_output_redirect > 1 || num_words < 1) {
        return !is_well_formed;
    }
    else {
        return is_well_formed;
    }
}
