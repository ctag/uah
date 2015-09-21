/**
 * IPC with Message Queues
 * Christopher Bero [csb0019@uah.edu]
 * Lab 5 - CPE 435
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
	key_t msgKey;
	int msgId;
	struct msqid_ds msgStat;
	char * input_string;
	short unsigned int input_size = 100;
	int isProcA; /* Is this process A */

	// Initialize
	msgKey = ftok("main.c", '5'); /* Ensure program is run from the correct path */
	if (msgKey == -1)
	{
		printf("\nError fetching key. Program must run from directory with main.c file. Exiting.\n");
		return(-1);
	}
	input_string = (char*)malloc(sizeof(char) * input_size);

	// Get message queue ID
	msgId = msgget(msgKey, (IPC_CREAT /*| IPC_EXCL*/ | S_IRUSR | S_IWUSR) );
	if (msgId == -1)
	{
		printf("\nError creating message queue. Exiting.\n");
		free(input_string);
		return(-1);
	}

	// Get the message queue's stats
	if (msgctl(msgId, IPC_STAT, &msgStat) == -1)
	{
		printf("\n\nError fetching stats for the message queue. Exiting.\n\n");
		closeAll(msgId, input_string);
		return(-1);
	}

	printf("\nmsg key:\t%d \nmsg id:\t\t%d \nnum msgs:\t%lu",
			msgKey, msgId, msgStat.msg_qnum);

	// Determine what role this process has
	printf("\nAm I process A or B (a/b)? >");
	if (prompt(input_string, input_size) != 0)
	{
		printf("\nError collecting user input. Exiting.\n");
		closeAll(msgId, input_string);
		return(-1);
	}
	if (input_string[0] == 'a' || input_string[0] == 'A')
	{
		printf("\nOK, I am process A. \nPlease load this program in a separate terminal as process B to continue!");
		isProcA = 1;
	}
	else if (input_string[0] == 'b' || input_string[0] == 'B')
	{
		printf("\nOK, I am process B. \nI will send the first message!");
		isProcA = 0;
		printf("\n\nEnter first message >");
		if (prompt(input_string, input_size) != 0)
		{
			printf("\nError collecting user input. Exiting.\n");
			return(-1);
		}
		if (msgsnd(msgId, input_string, input_size, IPC_NOWAIT) != 0)
		{
			printf("\nError sending message. Exiting.\n");
			closeAll(msgId, input_string);
			return(-1);
		}
		printf("\nMessage sent.");
	}

	// Each of Process A and B use the same holding loop to send messages over the queue
	while (1)
	{
		printf("\nI am waiting for a message.");
		if (msgrcv(msgId, input_string, input_size, 0, !IPC_NOWAIT) < 0)
		{
			printf("\nError receiving message. Exiting.\n");
			break;
		}
		if (!isProcA && strcmp(input_string, "Exit") == 0)
		{
			printf("\nExiting.\n");
			break;
		}
		printf("\nMessage received: %s", input_string);
		if (isProcA)
		{
			printf("\n\nEnter message for other process (Exit to quit both) >");
		} else {
			printf("\n\nEnter message for other process >");
		}

		if (prompt(input_string, input_size) != 0)
		{
			printf("\nError collecting user input. Exiting.\n");
			break;
		}
		if (msgsnd(msgId, input_string, input_size, IPC_NOWAIT) != 0)
		{
			printf("\nError sending message. Exiting.\n");
			break;
		}
		if (isProcA && strcmp(input_string, "Exit") == 0)
		{
			printf("\nExiting.\n");
			break;
		}
		printf("\nMessage sent.");
	}

	// Close and detach shm
	closeAll(msgId, input_string);

    return 0;
}
