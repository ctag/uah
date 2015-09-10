#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int child_1_mult (int num1, int num2)
{
	printf("Multiplying %d and %d = %d.\n", num1, num2, (num1*num2));
	return(num1 * num2);
}

int main (int argc, char * argv[]) 
{
    pid_t c_pid; // child pid
    pid_t wait_pid;
    pid_t p_pid; // parent pid
    int index = 0;
    p_pid = getpid(); // Store parent pid
	
    printf("argc: %d\n", argc);
    
	c_pid = fork();
	int c_exit;
	
	if (p_pid == getpid()) /* we are the parent process */
	{
		printf("I am the parent process, pid is %d \n", p_pid);
		fflush(stdout);
		wait_pid = wait(&c_exit);
		printf("I am the parent, and child is done with exit %d, %d.\n\n", WEXITSTATUS(c_exit), wait_pid);
		fflush(stdout);
	}
	
	else if (c_pid == 0) /* we are the child */
	{
		printf("I am child, pid: %d\n", getpid());
		fflush(stdout);
		child_1_mult(10, 20);
		return(245);
	}
		
    return(0);
}
