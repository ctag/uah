/**
 * Christopher Bero
 * CPE 412 - Exam 2
 * Problem 4
 */

#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>

// Calculate height at singular point
double curve (double x)
{
	return (x + sin(1/x));
}

// Thread operations
void worker(double x_start, double x_end, int num_bins, double * result)
{
	// Worker thread variables
    double local_result = 0.0;
    double local_start, local_end, local_interval, x;
    int i, local_bins;
    int rank = omp_get_thread_num();
    int num_threads = omp_get_num_threads();

    local_interval = (x_end - x_start)/num_bins;
    local_bins = num_bins / num_threads; // integer division
	local_start = x_start + rank*local_bins*local_interval;
	local_end = local_start + local_bins*local_interval;
	if (rank == (num_threads-1)) // you are last
	{
		local_end = x_end;
		local_bins = local_bins + (num_bins - (local_bins*num_threads));
	}
	x = 0.0;

	for (i = 0; i < local_bins; i++)
	{
		// 0.5 * (b1 + b2) * h
		double start, end;
		start = local_start + (local_interval*i);
		end = start + local_interval;
		local_result += 0.5*( curve(start) + curve(end) ) * local_interval;
	}
	printf("Thread: %d, interval: %lf, bins: %d, start: %lf, end: %lf, result: %lf\n", \
			rank, local_interval, local_bins, local_start, local_end, local_result);

#	pragma omp critical
	*result += local_result;
}

// Master thread operations
int main(int argc, char * argv[])
{
	// Thread 0 variables
    double result = 0;
    double x_start, x_end;
    int num_bins;
    int num_threads;

    if (argc != 5)
	{
		printf("Usage: ./p4_omp [start] [end] [threads] [bins]\n");
		exit (1);
	}
	else
	{
		x_start = strtod(argv[1], NULL);
		x_end = strtod(argv[2], NULL);
		num_threads = strtol(argv[3], NULL, 10);
		num_bins = strtol(argv[4], NULL, 10);
	}

	printf("Start: %lf, End: %lf, Threads: %d, Bins: %d\n", x_start, x_end, num_threads, num_bins);

#	pragma omp parallel num_threads(num_threads)
	worker(x_start, x_end, num_bins, &result);

	printf("Result: %lf\n", result);

    return 0;
}
