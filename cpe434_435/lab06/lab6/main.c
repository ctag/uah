/**
 * Simulated Process Scheduler
 * Christopher Bero [csb0019@uah.edu]
 * Lab 6 - CPE 435
 *
 * RR - Round Robin
 * PP - Priority Processing
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

// Process Struct
typedef struct process {
	int pid; 	/* Process ID; RR and PP */
	int burst; 	/* CPU burst time; RR and PP */
	int t_round; /* Time needed for process to complete; RR and PP */

	int working; /* Working time; RR only */

	int priority; /* Process priority; PP only */

	struct process * next; /* Access the next process in the list */
	struct process * previous; /* Acces the previous process; PP only */
} process;

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
//int strToInt (char * string, int * output)
//{
//	// Variables
//	unsigned int index;
//	index = 0;
//
//	while (string[index] != '\0')
//	{
//		if (isdigit(string[index]) == 0)
//		{
//			// not a digit
//			return(-1);
//		}
//		index++;
//	}
//	// All chars should be digits
//	*output = atoi(string);
//	return(0);
//}
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
void closeAll (int msgId, char * input_string)
{
	// Deallocate the message queue segment.
	msgctl(msgId, IPC_RMID, 0);

	free(input_string);
}

int main( int argc, char *argv[] )
{
	// Variables
	char * input_string;				/* User input */
	short unsigned int input_string_size = 100;/* Length of user input array */
	unsigned int time_quantum = 1;		/* Base unit of processing time */
	char * time_unit;					/* time unit being used */
	short unsigned int time_unit_size = 25; /* Allows for answers like "ms" or "milliseconds" */
	unsigned short int isProcRR = 1; 	/* Are we processing Round Robin? Otherwise priority */
	process * rootProc;					/* Root of single/double linked list */

	// Initialize
	input_string = (char*)malloc(sizeof(char) * input_string_size);
	time_unit = (char*)malloc(sizeof(char) * time_unit_size);

	// Determine what role this process has
	printf("\nAre we scheduling with (R)ound Robin or (P)riority Processing? (r/p) >");
	if (prompt(input_string, input_string_size) != 0)
	{
		printf("\nError collecting user input. Exiting.\n");
		//closeAll(msgId, input_string);
		return(-1);
	}
	if (input_string[0] == 'r' || input_string[0] == 'R')
	{
		printf("\nOK, I will schedule the tasks as Round Robin.");
		isProcRR = 1;
	}
	else if (input_string[0] == 'p' || input_string[0] == 'P')
	{
		printf("\nOK, I will schedule the tasks as Priority Processing.");
		isProcRR = 0;
		printf("\nOh no! This isn't implemented yet!\n");
		return(-1);
	}
	else
	{
		printf("\nInput doesn't seem to be any of 'r', 'R', 'p', 'P'. Exiting.\n");
		return(-1);
	}

	// Determine time units
	printf("\nWhat time units are we dealing with? (Default: 'ms') >");
	if (prompt(time_unit, input_string_size) != 0)
	{
		printf("\nError collecting user input. Exiting.\n");
		//closeAll(msgId, input_string);
		return(-1);
	}
	else if (input_string[0] == '\0')
	{
		time_unit = "ms";
	}

	// Set quantum if Round Robin
	if (isProcRR)
	{
		printf("\nPlease enter the number of %s for our time quantum >", time_unit);
		if (prompt(input_string, input_string_size) != 0)
		{
			printf("\nError collecting user input. Exiting.\n");
			//closeAll(msgId, input_string);
			return(-1);
		}
		else
		{
			time_quantum = strToInt(input_string);
			if (time_quantum <= 0)
			{
				printf("\nError, invalid ascii to int conversion. Exiting.\n");
				//closeAll(msgId, input_string);
				return(-1);
			}
		}
	}

	printf("\nType: %s, time units: %s, time quantum: %d", (isProcRR?"Round Robin":"Priority Processing"), time_unit, time_quantum);

	// Collect processes

	// Simulate scheduling

	// Close and detach shm
	//closeAll(msgId, input_string);

    return 0;
}
