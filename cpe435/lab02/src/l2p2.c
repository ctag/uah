/**
 * Lab 02
 * Program 2
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main (int argc, char * argv[]) 
{
    pid_t c_pid; // child pid
    pid_t p_pid; // parent pid
    int index = 0;
    int c_limit = atoi(argv[1]); // forking loop index
    p_pid = getpid(); // Store parent pid
	
	if (argc < 2)
	{
		printf("Must have second argument int.\n\n");
		return(-1);
	}
	
	if (c_limit%2 != 0) 
	{
		printf("Second argument must be even.\n\n");
		return(-1);
	}
	
    printf("argc: %d\n", argc);
    
    for (index = 1; index <= c_limit; index++)
    {
		c_pid = fork();
		int c_exit;
        if (p_pid == getpid()) /* we are the parent process */
        {
			printf("I am the parent process, child #%d pid is %d \n", index, c_pid);
			fflush(stdout);
			pid_t wait_pid;
			wait_pid = wait(&c_exit);
			printf("I am the parent process, child #%d is done with exit %d.\n\n", index, WEXITSTATUS(c_exit));
			fflush(stdout);
		}
		else if (c_pid == 0) /* we are the child */
		{
			exit(index-1);
		}
    }
    //printf("I am the parent, the child's pid is %d \n", c_pid);
    exit(0);
}
