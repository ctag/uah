#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main (int argc, char * argv[]) {
    pid_t c_pid;
    printf("The pid of the parent is %d \n", getpid());
    c_pid = fork();
    if (c_pid == 0) /* we are the child process */
    {
        printf("I am the child; my parent pid is %d \n", getppid());
        exit(0);
    }
    printf("I am the parent, the child's pid is %d \n", c_pid);
    exit(0);
}
