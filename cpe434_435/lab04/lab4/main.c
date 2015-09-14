/**
 * IPC with Shared Memory
 * Christopher Bero [csb0019@uah.edu]
 * Lab 4 - CPE 435
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
#include <sys/shm.h> 	// SHM - SHared Memory

/**
 * Write the code for two distinct C/C++ processes that are not part of a
 * parent-child relation. They both attach shared memory area containing
 * a new type structure with four INTEGERS (first-number, second-number,
 * Sum and Flag).The first process must set the values for first and
 * second numbers, then it update the value of flag to 1(which means
 * there is a new data).the second process is find the sum of these two
 * numbers and display the sum of the two values and changes the flag to zero.
 * Two processes continue running until the first process sets the value of flag to -1.
 */

struct summerType {
	int val1;
	int val2;
	int sum;
	int flag;
};

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
int strToInt (char * string, int * output)
{
	// Variables
	unsigned int index;
	index = 0;

	while (string[index] != '\0')
	{
		if (isdigit(string[index]) == 0)
		{
			// not a digit
			return(1);
		}
		index++;
	}
	// All chars should be digits
	*output = atoi(string);
	return(0);
}

void CloseAll (struct summerType * shmSum, int shmId, char * input_string)
{
	// Tell other processes to exit
	shmSum->flag = -1;

	// Detach shared memory
	shmdt(shmSum);

	// Deallocate the shared memory segment.
	shmctl (shmId, IPC_RMID, 0);

	free(input_string);
}

int main( int argc, char *argv[] )
{
	// Variables
	char * input_string;
	short unsigned int input_size = 15;
	int firstProg;
	int shmId;
	key_t shmKey;
	struct summerType * shmSum;
	struct shmid_ds shmStat;
	unsigned int shmSize = sizeof(struct summerType);

	// Initialize
	shmKey = ftok("main.c", '4'); /* Ensure program is run from the correct path */
	if (shmKey == -1)
	{
		printf("\nError fetching key. Exiting.\n");
		return(-1);
	}
	input_string = (char*)malloc(sizeof(char) * input_size);

	// Get shared memory ID
	shmId = shmget(shmKey, shmSize, (IPC_CREAT /*| IPC_EXCL*/ | S_IRUSR | S_IWUSR) );
	if (shmId == -1)
	{
		printf("\nError creating shared memory. Exiting.\n");
		return(-1);
	}

	// Attach shared memory to struct
	shmSum = (struct summerType *)shmat(shmId, 0, 0);
	if (shmSum < 0)
	{
		printf("\nError attaching shared memory. Exiting.\n");
		return(-1);
	}

	// Get the shared memory's stats
	if (shmctl(shmId, SHM_STAT, &shmStat) == -1)
	{
		printf("\n\nError fetching stats for the shared memory. Exiting.\n\n");
		CloseAll(shmSum, shmId, input_string);
		return(-1);
	}

	printf("\nshm key:\t%d \nshm id:\t\t%d \nshm size:\t%lu bytes \n# attached:\t%lu",
			shmKey, shmId, shmStat.shm_segsz, shmStat.shm_nattch);

	// Determine what role this process has
	if (shmStat.shm_nattch == 1)
	{
		printf("\nI detect that I am the first program. Please start the second instance.");
		fflush(stdout);
		firstProg = 1;
		while (shmctl(shmId, SHM_STAT, &shmStat) != -1 && shmStat.shm_nattch == 1)
		{
			// wait...
		}
	}
	else if (shmStat.shm_nattch == 2)
	{
		printf("\nI detect that I am the second program. No further input needed.\n");
		fflush(stdout);
		firstProg = 0;
	}
	else
	{
		printf("\nA weird number of processes are attached to the memory. Exiting.\n");
		return(-1);
	}

	if (firstProg == 1) /* Take input */
	{
		while (1)
		{
			printf("\n\nEnter first integer (q to quit) >");
			if (prompt(input_string, input_size) != 0)
			{
				printf("\nError collecting user input. Exiting.\n");
				break;
			}
			else if (input_string[0] == 'q')
			{
				shmSum->flag = -1;
				break;
			}

			shmSum->val1 = atoi(input_string);
			printf("Enter second integer >");
			if (prompt(input_string, input_size) != 0)
			{
				printf("\nError collecting user input. Exiting.\n");
				break;
			}
			shmSum->val2 = atoi(input_string);
			printf("Computing: %d + %d", shmSum->val1, shmSum->val2);
			shmSum->flag = 1;
			while (shmSum->flag == 1)
			{
				/*printf("\nFlag is 1. Exit? >");
				scanf("%d", &input_d);
				if (input_d == 0)
				{
					break;
				}*/
			}
			printf("\nResult: %d", shmSum->sum);
		}
	}

	else /* Compute sum */
	{
		while (1)
		{
			while (shmSum->flag == 0)
			{
				// Wait..
			}
			if (shmSum->flag < 0)
			{
				break;
			}
			else
			{
				shmSum->sum = shmSum->val1 + shmSum->val2;
				shmSum->flag = 0;
			}
		}
	}

	// Close and detach shm
	CloseAll(shmSum, shmId, input_string);

    return 0;
}
