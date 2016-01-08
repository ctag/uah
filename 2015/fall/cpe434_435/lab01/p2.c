#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main (int argc, char * argv[]) 
{
    pid_t c_pid; // child pid
    pid_t p_pid; // parent pid
    int index = 0; // forking loop index
    p_pid = getpid();

    printf("The pid of the parent is %d \n", getpid());
    printf("argc: %d\n", argc);
    
    c_pid = fork();
    for (index = 1; index <= 10; index++)
    {
        if (p_pid == getpid()) /* we are the parent process */
        {
            c_pid = fork();
            if (c_pid == 0) /* we are the child */
            {
                printf("I am the child; my pid is %d and my serial number is %d\n", getpid(), index);
                fflush(stdout);
                exit(0);
            }
        }
    }
    //printf("I am the parent, the child's pid is %d \n", c_pid);
    exit(0);
}
