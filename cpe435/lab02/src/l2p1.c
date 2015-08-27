/**
 * Lab 02
 * Program 1
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int child_2_add (int num1, int num2)
{
	printf("Adding %d and %d = %d.\n", num1, num2, (num1+num2));
	return(num1 + num2);
}

int child_1_sub (int num1, int num2)
{
	printf("Subtracting %d and %d = %d.\n", num1, num2, (num1-num2));
	return(num1 - num2);
}

int child_1_mult (int num1, int num2)
{
	printf("Multiplying %d and %d = %d.\n", num1, num2, (num1*num2));
	return(num1 * num2);
}

int main (int argc, char * argv[]) 
{
    pid_t c_pid; // child pid
    pid_t p_pid; // parent pid
    p_pid = getpid(); // Store parent pid

	c_pid = fork();
	int c_exit;
	
	if (p_pid == getpid()) /* we are the parent process */
	{
		printf("I am the parent process, pid is %d \n", p_pid);
		fflush(stdout);
		pid_t wait_pid;
		wait_pid = wait(&c_exit);
		printf("I am the parent, and child #%d is done with exit %d.\n\n", index, WEXITSTATUS(c_exit));
		fflush(stdout);
	}
	else if (c_pid == 0) /* we are the child */
	{
		c_pid = getpid();
		child_1_sub(10, 3);
		pid_t c2_pid;
		int *c2_exit;
		int ret;
		c2_pid = fork();
		if (c_pid == getpid())
		{
			wait(c2_exit);
			ret = child_1_mult(10, 3);
			exit(ret);
		} else {
			ret = child_2_add(10, 3);
			exit(ret);
		}
	}
		
    return(0);
}







