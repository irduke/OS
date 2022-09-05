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

void parse_and_run_command(const std::string &command) {
    /* TODO: Implement this. */
    /* Note that this is not the correct way to test for the exit command.
       For example the command "   exit  " should also exit your shell.
     */

    if(command == "exit") {
        exit(0);
    }

    // split string into individual commands & tokens
    std::vector<std::vector<std::string>> tokens;
    std::stringstream s(command);
    std::string temp;
    int numCommands = 1;
    std::vector<std::string> firstVec;
    tokens.push_back(firstVec);
    while(std::getline(s, temp, ' ')) {
        if(temp == "|") {
            numCommands++;
            std::vector<std::string> tempVec;
            tokens.push_back(tempVec);
        }
        else {
            tokens[numCommands-1].push_back(temp);

        }
    }

    for(int i = 0; i < numCommands; i++) {
        std::vector<std::string> command = tokens[i];
        std::string delimiter = "/bin/";
        std::string parsed_command = command[0].substr(command[0].find(delimiter)+delimiter.length());
        int status;
        
        std::string func = command[0];
        const char *args;
        if(command.size() == 1) {
            args = (char *)0;
        }
        else {
            args = command[1].c_str();
        }

        pid_t pid = fork();
        if(pid == 0) {
            execlp(func.c_str(), parsed_command.c_str(), args, (char *)NULL);
        }
        else if(pid > 0) {
            waitpid(pid, &status, 0);
        }
        else {
            std::cout << "this was an error";
        }

        if(WIFEXITED(status)) {
            std::cerr << func << " exit status: " << WEXITSTATUS(status) << std::endl;
        }
    }
    
}

int main(void) {
    std::string command;
    std::cout << "> ";
    while (std::getline(std::cin, command)) {
        parse_and_run_command(command);
        std::cout << "> ";
    }
    return 0;
}
