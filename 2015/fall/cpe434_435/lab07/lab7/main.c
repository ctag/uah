/**
 * Posix Signals
 * Christopher Bero [csb0019@uah.edu]
 * Lab 7 - CPE 435
 *
 * This program will create a child process,
 * block for 10 seconds, and then allow ctrl+c
 * to close both.
 */

#include <stdio.h>
#include <stdlib.h>

// Other common headers
#include <string.h> 	// For manipulating string and char* types
#include <unistd.h>
#include <ctype.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ipc.h>	// IPC - Inter Process Communication
#include <sys/shm.h> 	// SHM - message queue
#include <sys/msg.h>	// MSG - Message Queues
#include <signal.h>
#include <time.h>

// These act as flags to be set by the signal handlers
volatile short unsigned int interruptHere = 0; // ctrl-c SIGINT received
volatile short unsigned int termHere = 0; // SIGTERM received

/**
 * rmNewline
 * Strips the ending '\n' char from an array
 */
void rmNewline (char * string)
{
	// Variables
	int index;
	index = 0;

	// Iterate through char array until end
	while (string[index] != '\n' && string[index] != '\0')
	{
		index++;
	}
	string[index] = '\0';
}

/**
 * Prompt
 * Prints a prompt, reads user input
 */
int prompt(char * input, short unsigned int input_len)
{
	// Collect and Verify input
	if (fgets(input, input_len, stdin) == NULL)
	{
		return(-1);
	}
	rmNewline(input);
	return(0);
}

/**
 * strToInt
 * Checks that all chars in a str/array are digits
 * then converts them to an int
 * Returns 0 on success.
 */
int strToInt (char * string)
{
	// Variables
	unsigned int index;
	index = 0;

	while (string[index] != '\0')
	{
		if (isdigit(string[index]) == 0)
		{
			// not a digit
			return(-1);
		}
		index++;
	}
	// All chars should be digits
	return(atoi(string));
}

/**
 * closeAll
 * close shm and free pointers
 */
void closeAll (char * time_unit, char * input_string)
{
	free(input_string);
	free(time_unit);
}

void parent_signal_handler (int signum)
{
	signal(SIGINT, parent_signal_handler);
	interruptHere = 1;
}

void child_signal_int_handler (int signum)
{
	signal(SIGINT, child_signal_int_handler);
	//printf("\nChild process caught int signal %d\n", signum);
}

void child_signal_term_handler (int signum)
{
	signal(SIGTERM, child_signal_term_handler);
	//printf("\nChild process caught term signal %d\n", signum);
	termHere = 1;
}

int main( int argc, char *argv[] )
{
	pid_t parentPid = getpid();
	pid_t childPid;
	time_t seconds;
	int status;

	printf("\nCreating child process");
	fflush(stdout);
	childPid = fork();

	if (parentPid == getpid())
	{
		// We are parent process
		printf("\nSetting up parent signal handler.");
		fflush(stdout);
		signal(SIGINT, parent_signal_handler);
		printf("\nChild process created, 10 seconds until both may be closed.");
		fflush(stdout);
		seconds = time(NULL);
	} else {
		// We are child process
		printf("\nSetting up child signal handler.");
		fflush(stdout);
		signal(SIGINT, child_signal_int_handler);
		signal(SIGTERM, child_signal_term_handler);
	}

	while (1)
	{
		if (interruptHere == 1)
		{
			interruptHere = 0; // Reset the flag
			// Interrupt happened
			if (parentPid == getpid())
			{
				if ((time(NULL) - seconds) > 10)
				{
					// 10 seconds has elapsed
					printf("\nIt's been over 10 seconds, halting both processes.");
					printf("\nParent is PID %d", parentPid);
					fflush(stdout);
					kill(childPid, SIGTERM);
					wait(&status);
					exit(SIGINT);
				}
				else
				{
					// 10 seconds has not elapsed
					printf("\nNu-uh-uh, hasn't been 10 seconds yet!");
					fflush(stdout);
				}
			}
		}
		if (termHere == 1)
		{
			printf("\nChild process is PID %d\n", getpid());
			fflush(stdout);
			exit(SIGTERM);
		}
	}

    return 0;
}

