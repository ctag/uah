/**
 * Server, Client
 * Christopher Bero [csb0019@uah.edu]
 * Lab 9 - CPE 435
 *
 * This program will be either a server
 * or client, and sort words.
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
#include <sys/time.h>	// For measuring execution time
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <signal.h>
#include <time.h>
#include <math.h>
#include <pthread.h>

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

void error(char *msg)
{
    perror(msg);
    exit(1);
}

int main()
{
	int sockfd, newsockfd, portno, clilen, n;

	// Get number of threads
	printf("\nPlease enter the number of threads to execute >");
	if (prompt(input_string, 100) != 0)
	{
		printf("\nError collecting user input. Exiting.\n");
		//closeAll(msgId, input_string);
		return(-1);
	}
	else
	{
		num_threads = strToInt(input_string);
		if (num_threads <= 0)
		{
			printf("\nError, invalid ascii to int conversion. Exiting.\n");
			//closeAll(msgId, input_string);
			return(-1);
		}
	}

    printf("Hello world!\n");
    return 0;
}
