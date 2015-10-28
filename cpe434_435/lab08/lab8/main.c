/**
 * Posix Threads
 * Christopher Bero [csb0019@uah.edu]
 * Lab 8 - CPE 435
 *
 * This program will estimate the area
 * associated with a differential equation.
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
#include <signal.h>
#include <time.h>
#include <math.h>
#include <pthread.h>

#define PARALLEL 1 /* Flag for compilation */
#define QUANTA 0.0000005 /* float point error */

typedef struct thread_data {
	unsigned int intervals;
	unsigned int t_id;
	long double x_step;
	long double x_start;
	long double area;
} thread_data;

/* copied from cpe412 hw3 */
#define TIMER_CLEAR     (tv1.tv_sec = tv1.tv_usec = tv2.tv_sec = tv2.tv_usec = 0)
#define TIMER_START     gettimeofday(&tv1, (struct timezone*)0)
#define TIMER_ELAPSED   ((tv2.tv_usec-tv1.tv_usec)+((tv2.tv_sec-tv1.tv_sec)*1000000.0))
#define TIMER_STOP      gettimeofday(&tv2, (struct timezone*)0)
struct timeval tv1,tv2;

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

double calcArea (double x_start, double x_step, unsigned int intervals)
{
	// Variables
	long double area;
	long double x_left, y_left;
	long double x_right, y_right;
	unsigned int index;

	// Calculate area
	area = 0.0;
	x_left = x_start;
	y_left = 4.0*sqrtl(1.0 - (x_left*x_left));
	//printf("\nStep: %Lf", x_step);
	for (index = 0; index < intervals; ++index)
	{
		x_right = x_left + x_step;
		if (fabs(x_right - 1.0) < QUANTA || x_right > 1.0)
		{
			x_right = 1.0; // Account for errors that ruin sqrt
		}
		y_right = 4.0*sqrtl(1.0 - (x_right*x_right));
		//printf("\nArea: %Lf, y_left %Lf, y_right: %Lf, x_right: %Lf, subarea: %Lf", area, y_left, y_right, x_right, ((y_left + y_right)/2.0)*x_step);
		//area += ((y_left + y_right)/2.0)*x_step; /* Trapezoidal decomp */
		area += y_left*x_step; /* Rect decomp */
		y_left = y_right;
		x_left = x_right;
	}
	return(area);
}

void * thread_worker (void * args)
{
	thread_data *data = (thread_data*)args;
	//printf("\nThread: %d, intervals: %d, x start: %Lf, x step: %Lf.", data->t_id, data->intervals, data->x_start, data->x_step);

	data->area = calcArea(data->x_start, data->x_step, data->intervals);

	return 0;
}

int main()
{
	// Variables
	long double area, x_step, t_domain;
	char input_string[100];
	unsigned int index;
	pthread_t * threads;
	thread_data * thr_data;
	unsigned int intervals;
	unsigned int num_threads;

	// Setup parallel or serial
	if (!PARALLEL)
	{
		printf("\nThis is the serial program.");
	}
	else
	{
		printf("\nThis is the parallel program.");
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
		threads = (pthread_t*)malloc(sizeof(pthread_t)*num_threads);
		thr_data = (thread_data*)malloc(sizeof(thread_data)*num_threads);
	}

	// Get number of intervals
	printf("\nPlease enter the number of intervals >");
	if (prompt(input_string, 100) != 0)
	{
		printf("\nError collecting user input. Exiting.\n");
		//closeAll(msgId, input_string);
		return(-1);
	}
	else
	{
		intervals = strToInt(input_string);
		if (intervals <= 0)
		{
			printf("\nError, invalid ascii to int conversion. Exiting.\n");
			//closeAll(msgId, input_string);
			return(-1);
		}
	}

	// Start clock
	TIMER_CLEAR;
	TIMER_START;

	// Compute area for serial and parallel
	area = 0.0;
	x_step = (1.0 / intervals);
	if (!PARALLEL)
	{
		area = calcArea(0.0, x_step, intervals);
	}
	else
	{
		t_domain = (intervals / num_threads); /* Number of intervals per thread */
		// Check that threads < iterations
		if (num_threads > intervals)
		{
			printf("\nError, number of threads must be less than number of intervals. Exiting.");
			return(-1);
		}
		for (index = 0; index < num_threads; ++index)
		{
			thr_data[index].x_step = x_step;
			thr_data[index].x_start = (index * t_domain * x_step);
			thr_data[index].intervals = (((index+1)*t_domain*x_step)-thr_data[index].x_start)/(x_step-QUANTA);
			if (index == (num_threads-1))
			{
				thr_data[index].intervals = (1.0-thr_data[index].x_start)/(x_step-QUANTA);
			}
			thr_data[index].t_id = index;
			thr_data[index].area = 0.0;
			pthread_create(&threads[index], NULL, thread_worker, &thr_data[index]);
		}
		for (index = 0; index < num_threads; ++index)
		{
			pthread_join(threads[index], NULL);
			//printf("\nGot: %d: %Lf", index, thr_data[index].area);
			area += thr_data[index].area;
		}
	}

	TIMER_STOP;

	printf("\nArea estimation: %Lf", area);

	printf("\nTime elapsed: %lfs\n", TIMER_ELAPSED/1000000.0);

	if (PARALLEL)
	{
		free(threads);
		free(thr_data);
	}

    return 0;
}





