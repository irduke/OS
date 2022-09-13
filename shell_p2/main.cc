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
#include <fcntl.h>
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
    pid_t parent_pid;
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

bool is_well_formed(std::vector<std::string> tokens);

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
    std::vector<cmd> command_queue;
    std::string t;

    while(s >> t) {
        tokens.push_back(t);
    }

    std::string curr_token;
    int num_tokens = tokens.size();
    int token_counter = 0;

    if(!is_well_formed(tokens)) {
        std::cout << "Invalid command" << std::endl;
        exit(0);
    }

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
        curr_command.args.push_back(NULL);
        command_queue.push_back(curr_command);
    }



    int pipes[MAX_NUM_TOKENS][2];
    bool piped = (command_queue.size() > 1);
    int fd_read = -1;
    int fd_write = -1;
    int fd_prev = -1;

    for (size_t i = 0; i < command_queue.size(); i++) {
        cmd run_command = command_queue[i];
        if (piped && i < command_queue.size() - 1) {
            if (pipe(pipes[i]) < 0) {
                perror("Pipe error");
                exit(errno);
            }
            fd_read = pipes[i][0];
            fd_write = pipes[i][1];
        }

        pid_t pid = fork();
        if(pid == 0) {
            //Child
            if (piped) {
                //read end of pipe
                if (i > 0) {
                    //anything but initial cmd
                    dup2(fd_prev, STDIN_FILENO);
                }
                close(fd_prev);
            }
            //write end of pipe
            if (i < command_queue.size() - 1) {
                dup2(fd_write, STDOUT_FILENO);
                close(fd_read);
                close(fd_write);
            }

            //setup input redirection if need be
            if (strcmp(run_command.redir_in, "none") != 0) {
                int input_file = open(run_command.redir_in, O_RDONLY);
                if (input_file < 0) {
                    perror("Error opening input file");
                    exit(errno);
                }
                dup2(input_file, STDIN_FILENO);
            }

            //setup output redirection if need be
            if (strcmp(run_command.redir_out, "none") != 0) {
                int output_file = open(run_command.redir_in, O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
                if (output_file < 0) {
                    perror("Error opening output file");
                    exit(errno);
                }
                dup2(output_file, STDOUT_FILENO);
            }

            char **argv = &run_command.args[0];
            execvp(run_command.func, argv);
            perror("execvp");
            exit(errno);
        }
        else if(pid > 0) {
            //Parent process, wait for child
            run_command.parent_pid = pid;

            if (piped) {
                if (i > 0) {
                    close(fd_prev);
                }
                if (i < command_queue.size() - 1) {
                    fd_prev = fd_read;
                }
                close(fd_write);
            }
        }
        else {
            std::cerr << "Fork" << std::endl;
        }
    }

    int status;
    for (size_t i = 0; i < command_queue.size(); i++) {
        status = 0;
        waitpid(command_queue[i].parent_pid, &status, 0);
        std::cout << command_queue[i].func << " exit status: " << WEXITSTATUS(status) << std::endl;
    }
}

void init_cmd(cmd * command) {
    command->arg_index = 0;
    command->redir_in = "none";
    command->redir_out = "none";
    command->parent_pid = 0;
}

bool is_word(std::string token) {
    // Uses regex to check if a string is a word token
    return std::regex_match(token, std::regex("[^<>|]+"));
}

bool is_well_formed(std::vector<std::string> tokens) {
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

    if(!is_word(tokens[0]) || !is_word(tokens.back())) {
        // first and last token MUST be a word
        return false;
    }

    for(size_t i = 0; i < tokens.size(); i++) {
        if(tokens[i] != "|") {  
            if(i < tokens.size()-1) {
                // verify redirect character & word token combination
                if((tokens[i] == "<") && is_word(tokens[i+1])) num_input_redirect++;
                else if((tokens[i] == ">") && is_word(tokens[i+1])) num_output_redirect++;
                else if((tokens[i] == "<") && !is_word(tokens[i+1])) return false;
                else if((tokens[i] == ">") && !is_word(tokens[i+1])) return false;
            }
            if(is_word(tokens[i])) num_words++;
        }
        else {  // check for previous command & reset counts
            if(num_input_redirect > 1 || num_output_redirect > 1 || num_words < 1) {
                return !is_well_formed;
            }
            num_input_redirect = 0;
            num_output_redirect = 0;
            num_words = 0;
            if((i < tokens.size()-1) && !is_word(tokens[i+1])) {
                return false;
            }
        }  
    }

    if(num_input_redirect > 1 || num_output_redirect > 1 || num_words < 1) {
        return !is_well_formed;
    }
    else {
        return is_well_formed;
    }
}
