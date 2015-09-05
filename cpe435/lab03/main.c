/**
 * BAMBASH - The Born Again (as Middleware) Bourne Again SHell
 * Christopher Bero [csb0019@uah.edu]
 * Lab 03 - CPE 435
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <ctype.h> /* isdigit */
#include <fcntl.h>

/**
 * strToSUInt
 * Checks that all chars in a str/array are digits
 * then converts them to an int
 * Returns 0 on success.
 */
int strToSUInt (char * string, short unsigned int * output)
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
void prompt(char * input, short unsigned int input_len)
{
	// Collect input
	printf("\n> ");

	// Verify input
	if (fgets(input, input_len, stdin) == NULL)
	{
		printf("\nInput error, abandoning instance.");
		return;
	}
	rmNewline(input);
	//printf("\nYou entered: %s", input);
	//return input;
}

void deallocateCmds (char ** cmd, short unsigned int cmdSize)
{
	if (cmd == NULL)
	{
		return;
	}
	short unsigned int index;
	for (index = 0; index < cmdSize; ++index)
	{
		free(cmd[index]);
	}
	free(cmd);
	cmd = NULL;
}

/**
 * Main
 * Does stuff
 */
int main()
{
	// Variables
	char * input; // char array to hold user input
	short unsigned int * input_len; // size of input

	// Initialization
	input_len = (short unsigned int *)malloc(sizeof(short unsigned int));
	input = (char *)malloc(sizeof(char)*10);

	if (input_len == NULL || input == NULL)
	{
		printf("\nMemory initialization failed. Halting.\n");
		fflush(stdout);
		return(-3);
	}

    printf("\nWelcome to bambash.");

    // Gather input buffer size
    printf("\nEnter the desired input buffer size (default 200): ");
    if (fgets(input, 10, stdin) == NULL)
	{
		printf("\nInvalid input. A default buffer of 200 will be used.");
		*input_len = 200;
	}
	rmNewline(input);
	if (strToSUInt(input, input_len) != 0)
	{
		printf("\nInvalid digits. A default buffer of 200 will be used.");
		*input_len = 200;
	}
	if (*input_len < 10)
	{
		printf("\nInput buffer must be at least ten characters long. Defaulting to 200.");
		*input_len = 200;
	}
	free(input);
	input = (char *)malloc(sizeof(char) * *input_len);

	if (input == NULL)
	{
		printf("\nMemory initialization failed. Halting.\n");
		fflush(stdout);
		return(-2);
	}

	// Loop variables
	char * token; // Chunk of input from strtok
	char ** cmd1 = NULL; // First command, default
	char ** cmd2 = NULL; // Second command if pipe is used

    while (1)
	{
		// Get user input
		prompt(input, *input_len);

		short unsigned int cmd1Index; // Index for traversing cmd1
		short unsigned int cmd2Index; // Index for traversing cmd2
		short unsigned int index = 0; // General purpose index
		short unsigned int procMode = 0; // 0: 1 command, 1: command | command, 2: command > redirect, 3: invalid
		short unsigned int cmd1Size = 1; // Length of cmd1 w/ ending NULL
		short unsigned int cmd2Size = 1; // Length of cmd2
		short unsigned int countState = 0; // 0: counting cmd1 args, 1: counting cmd2 args, 2: counting redirect (can only be 1 long)

		// Parse input
		while (input[index] != '\0')
		{
			if (input[index] == ' ')
			{
				if (countState == 0)
					cmd1Size++;
				else
					cmd2Size++;
			}
			else if (input[index+1] == '\0' && countState == 0)
			{
				cmd1Size++;
			}
			else if (input[index] == '|')
			{
				if (procMode != 0 || countState != 0)
				{
					procMode = 3;
					break;
				}
				countState = 1;
				procMode = 1;
			}
			else if (input[index] == '>')
			{
				if (procMode != 0 || countState != 0)
				{
					procMode = 3;
					break;
				}
				countState = 1;
				procMode = 2;
			}
			index++;
		}

		if (procMode == 3)
		{
			printf("\nInvalid input detected.");
			continue;
		}

		// Debugging output of parsed input
		/*if (procMode == 0)
		{
			printf("\nOne Command: %d", cmd1Size);
		} else if (procMode == 1) {
			printf("\nPiped command: %d | %d", cmd1Size, cmd2Size);
		} else if (procMode == 2) {
			printf("\nRedirection: %d > %d", cmd1Size, cmd2Size);
		} else {
			printf("\nError!");
		}*/

		// Allocate command memory
		cmd1 = (char **)malloc((cmd1Size) * sizeof(char*));
		for (index = 0; index < cmd1Size; ++index)
		{
			cmd1[index] = (char*)malloc(*input_len * sizeof(char));
		}
		cmd2 = (char **)malloc((cmd2Size) * sizeof(char*));
		for (index = 0; index < cmd2Size; ++index)
		{
			cmd2[index] = (char*)malloc(*input_len * sizeof(char));
		}

		// Grab first token
		token = strtok(input, " ");
		if (token == NULL)
		{
			deallocateCmds(cmd1, cmd1Size);
			deallocateCmds(cmd2, cmd2Size);
			continue;
		}

		// Parse bambash specific commands (limited to the first word/token)
		if (strcmp("exit", token) == 0)
		{
			printf("\nExit command received. Closing bambash.");
			fflush(stdout);
			deallocateCmds(cmd1, cmd1Size);
			deallocateCmds(cmd2, cmd2Size);
			break;
		}

		// token parsing loop
		countState = 0;
		cmd1Index = 0;
		cmd2Index = 0;
		int c1_exit;
		int c2_exit;
		while (token != NULL)
		{
			// Control state machine
			if (strcmp(token, "|") == 0)
			{
				countState = 1;
				token = strtok(NULL, " ");
				continue;
			}
			else if (strcmp(token, ">") == 0)
			{
				countState = 2;
				token = strtok(NULL, " ");
				continue;
			}
			// Load tokens
			if (countState == 0)
			{
				strcpy(cmd1[cmd1Index], token);
				cmd1Index++;
			} else {
				strcpy(cmd2[cmd2Index], token);
				cmd2Index++;
			}
			token = strtok(NULL, " ");
		}
		cmd1[cmd1Index] = (char*)NULL;
		cmd2[cmd2Index] = (char*)NULL;

		// Create subprocesses and execute commands
		if (procMode == 0 || procMode == 2) // One command or redirection
		{
			if (fork() == 0)
			{
				// Child
				if (procMode == 2) // Redirection
				{
					int output;
					output = open(cmd2[0], O_WRONLY | O_CREAT | O_TRUNC, 0666);
					dup2(output, 1);
					close(output);
				}
				execvp(cmd1[0], cmd1);
			}
			else
			{
				// Parent
				wait(&c1_exit);
				//printf("\nChild exit status: %d", WEXITSTATUS(c1_exit));
			}
		}
		else if (procMode == 1) // Piped commands
		{
			int fd[2];
			pipe(fd);
			if (fork() == 0)
			{
				// Child2 - executes cmd2
				dup2(fd[0], 0);
				close(fd[1]); // Close input
				execvp(cmd2[0], cmd2);
			}
			else if (fork() == 0)
			{
				// Child1 - executes cmd1
				dup2(fd[1], 1);
				close(fd[0]); // Close output
				execvp(cmd1[0], cmd1);
			}
			else
			{
				// Parent
				close(fd[0]);
				close(fd[1]);
				wait(&c1_exit);
				wait(&c2_exit);
				//printf("\nChildren exit status: %d, %d", WEXITSTATUS(c1_exit), WEXITSTATUS(c2_exit));
			}
		}

		// Free command memory
		deallocateCmds(cmd1, cmd1Size);
		deallocateCmds(cmd2, cmd2Size);
	} // end while

	free(input_len);
	free(input);
    return 0;
}
















