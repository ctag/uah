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

// Global variables
key_t shmKey =

int main( int argc, char *argv[] )
{
	// Variables
	char input_c;
	int input_d;

	// Initialization

    printf("\nAm I the number producer? (y/n) >");
    input_c = (char)fgetc(stdin);
    while (input_c == EOF || (input_c != 'y' && input_c != 'n'))
	{
		printf("\nInvalid input. Please enter again: ");
		fflush(stdout);
		input_c = (char)fgetc(stdin);
		while (input_c == '\n')
		{
			input_c = (char)fgetc(stdin);
		}
	}

	if (input_c == 'y')
	{
		printf("\nOK, cool.");
	}
	else if (input_c == 'n')
	{
		printf("\nAlright, so I'll wait around for some numbers to crunch.");
	}
	else
	{
		printf("\nInvalid input. This is an identity crisis.\n");
		return(-2);
	}

    return 0;
}
