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


int main( int argc, char *argv[] )
{
	// Variables
	int input_d;
	int firstProg;
	int shmId;
	key_t shmKey;
	shmKey = ftok("main.c", '4');
	if (shmKey == -1)
	{
		printf("\nError fetching key. Exiting.\n");
		return(-1);
	}
	struct summerType * shmSum;
	struct shmid_ds shmStat;
	//shmSum.flag = 0;
	unsigned int shmSize = sizeof(struct summerType);

	shmId = shmget(shmKey, shmSize, (IPC_CREAT /*| IPC_EXCL*/ | S_IRUSR | S_IWUSR) );
	if (shmId == -1)
	{
		printf("\nError creating shared memory. Exiting.\n");
		return(-1);
	}

	shmSum = (struct summerType *)shmat(shmId, 0, 0);

	if (shmctl(shmId, SHM_STAT, &shmStat) == -1)
	{
		printf("\n\nError fetching stats for the shared memory. Exiting.\n\n");
		return(-1);
	}

	printf("\nshm key:\t%d \nshm id:\t\t%d \nshm size:\t%lu bytes \n# attached:\t%lu", shmKey, shmId, shmStat.shm_segsz, shmStat.shm_nattch);

	if (shmStat.shm_nattch == 1)
	{
		printf("\nI detect that I am the first program. Please start the second instance.");
		firstProg = 1;
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
			printf("\n\nEnter first integer (0 to quit) >");
			scanf("%d", &input_d);
			if (input_d == 0)
			{
				break;
			}
			shmSum->val1 = input_d;
			printf("Enter second integer >");
			scanf("%d", &input_d);
			shmSum->val2 = input_d;
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
			while (shmSum->flag != 1)
			{
				// Wait..
			}
			shmSum->sum = shmSum->val1 + shmSum->val2;
			shmSum->flag = 0;
		}
	}




	// Detach shared memory
	shmdt(shmSum);

	// Deallocate the shared memory segment.
	shmctl (shmId, IPC_RMID, 0);

    return 0;
}
