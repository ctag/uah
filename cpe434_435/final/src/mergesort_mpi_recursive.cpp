/**
 * Christopher Bero
 * CPE 434_435
 * Final Project
 * Distributed Merge Sort - Recursive
 */

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <math.h>

/**
 * headers for an MPI/OMP program
 */
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <omp.h>
#include <mpi.h>

#define DEBUG true			/* whether to output matrices or not */
#define MX_SZ 320
#define SEED 2397           /* random number seed */
#define MAX_VALUE  100.0    /* maximum size of array elements A, and B */

/* copied from mpbench */
#define TIMER_CLEAR     (tv1.tv_sec = tv1.tv_usec = tv2.tv_sec = tv2.tv_usec = 0)
#define TIMER_START     gettimeofday(&tv1, (struct timezone*)0)
#define TIMER_ELAPSED   ((tv2.tv_usec-tv1.tv_usec)+((tv2.tv_sec-tv1.tv_sec)*1000000))
#define TIMER_STOP      gettimeofday(&tv2, (struct timezone*)0)
struct timeval tv1,tv2;

void swap (long int * data, long int first, long int second)
{
	long int tmp = data[first];
	data[first] = data[second];
	data[second] = tmp;
}

void merge (long int * data, long int low, long int middle, long int high)
{
	long int lsize, rsize, lindex, rindex, dindex, i;
		lsize = (middle-low)+1;
		rsize = (high-(middle+1))+1;
		lindex = 0;
		rindex = 0;
		dindex = low;
		//printf("lsize: %ld, rsize: %ld\n", lsize, rsize);
		long int *ltmp;
		long int *rtmp;
		ltmp = (long int *)malloc(sizeof(long int) * lsize);
		rtmp = (long int *)malloc(sizeof(long int) * rsize);
		for (i = 0; i < lsize; i++)
		{
			ltmp[i] = data[low+i];
		}
		for (i = 0; i < rsize; i++)
		{
			rtmp[i] = data[middle+1+i];
		}
		while (dindex <= high)
		{
			if (lindex >= lsize)
			{
				//printf("Data #%ld = l>size rtmp [%ld]%ld\n", dindex, rindex, rtmp[rindex]);
				data[dindex] = rtmp[rindex];
				dindex++;
				rindex++;
				continue;
			}
			if (rindex >= rsize)
			{
				//printf("Data #%ld = r>size ltmp [%ld]%ld\n", dindex, lindex, ltmp[lindex]);
				data[dindex] = ltmp[lindex];
				dindex++;
				lindex++;
				continue;
			}
			if (ltmp[lindex] < rtmp[rindex])
			{
				//printf("Data #%ld = ltmp [%ld]%ld\n", dindex, lindex, ltmp[lindex]);
				data[dindex] = ltmp[lindex];
				dindex++;
				lindex++;
			}
			else
			{
				//printf("Data #%ld = rtmp [%ld]%ld\n", dindex, rindex, rtmp[rindex]);
				data[dindex] = rtmp[rindex];
				dindex++;
				rindex++;
			}
		}
		/*
		printf("ltmp: ");
		for (i = 0; i < lsize; i++)
		{
			printf("[%ld]%ld, ", i, ltmp[i]);
		}
		printf("\n");
		printf("rtmp: ");
		for (i = 0; i < rsize; i++)
		{
			printf("[%ld]%ld, ", i, rtmp[i]);
		}
		printf("\n");
		*/
		free(ltmp);
		free(rtmp);
}

void sort(long int * data, long int low, long int high)
{
	// Variables
	long int size = (high - low) + 1;
	long int middle = ((high-low)/2)+low;
	//if (size > 1000)
		//printf("Size: %ld, low: %ld, middle: %ld, high: %ld\n", size, low, middle, high);
	// Divide and merge large arrays
	if (size > 1)
	{
		sort(data, low, middle);
		sort(data, middle+1, high);
		merge(data, low, middle, high);
	}
	/*
	printf("Sorted Data: ");
	for (i = low; i <= high; i++)
	{
		printf("%ld, ", data[i]);
	}
	printf("\n\n");
	*/
}

/*
   MAIN ROUTINE: summation of a number list
*/
int main( int argc, char *argv[])
{
	// Variables
    long int i; 		/* indexes */
	long int *global_data, *local_data; 	/* random array */
	long int global_size, local_size, local_start;
	//unsigned int *tcount;

	// MPI variables
	int nmtsks, rank; 		/* default MPI variables */

	/**
	 * MPI initialization
	 */
	MPI_Init(&argc,&argv); 					/* initalize MPI environment */
	MPI_Comm_size(MPI_COMM_WORLD,&nmtsks);	/* find total number of tasks */
	MPI_Comm_rank(MPI_COMM_WORLD,&rank); 	/* get task identity number */

	//tcount = new (nothrow) unsigned int;

	/**
	 * Rank 0 sets the stage
	 * collects data size
	 * fills array with random numbers
	 */
	if (rank == 0)
	{
		if (argc != 2)
		{
			printf("Usage: ./mergesort_serial <data_count>");
			exit(EXIT_FAILURE);
		}
		else
		{
			global_size = (long int)atol(argv[1]);
		}

		// Instantiate memory
		global_data = (long int*)malloc(sizeof(long int) * global_size);
		if (!global_data)
		{
			printf("Memory allocation failed. \n");
			exit(EXIT_FAILURE);
		}

		// Generate psudorandom data
		srand48(SEED);
		for (i = 0; i < global_size; i++)
		{
			global_data[i] = (long int)lrand48();
		}

		// output data
		if (DEBUG)
		{
			for (i = 0; i < global_size; i++)
			{
				printf("Data: %ld\n", global_data[i]);
			}
			printf("\n");
		}
		TIMER_CLEAR;
		TIMER_START;
	}

	/**
	 * Broadcast data to all
	 */
	MPI_Bcast(&global_size, 1, MPI_LONG, 0, MPI_COMM_WORLD);
	if (rank != 0)
	{
		global_data = (long int *)malloc(sizeof(long int) * global_size);
	}

	/**
	 * Calculate subproblem indexes
	 */
	local_size = (global_size / nmtsks);
	local_start = (local_size * rank);

	/**
	 * If we're the last proc,
	 * extend the group to any missed elements
	 */
	if (rank == (nmtsks-1))
	{
		local_size = global_size - local_start;
	}

	int vSizes[nmtsks]; /* Size of segment */
	int vDisps[nmtsks]; /* Offset of segment from 0 */
	long int elemStart, elemEnd;
	long int rootPartial = (global_size / nmtsks); /* is the same for rank 0->(n-2) */
	long int lastPartial = (global_size - (rootPartial * (nmtsks-1)));
	for (i=0; i< (long int)nmtsks; ++i)
	{
		elemStart = floor((i*rootPartial));
		if (i == (long int)(nmtsks-1))
		{
			elemEnd = global_size-1;
		} else {
			elemEnd = (elemStart+rootPartial)-1;
		}
		vSizes[i] = (elemEnd - elemStart) + 1;
		vDisps[i] = (elemStart);
	}

	local_data = (long int *)malloc(sizeof(long int) * vSizes[rank]);
	if(local_data==NULL)
	{
		cout <<"ERROR:  Insufficient Memory" << endl << flush;
		exit(1);
	}

	MPI_Scatterv(global_data, vSizes, vDisps, MPI_LONG, local_data, vSizes[rank], MPI_LONG, 0, MPI_COMM_WORLD);

//	if (rank == 0)
//	{
//		printf("Local size: %ld, rootPartial: %ld, global size: %ld, lastPartial: %ld\n", local_size, rootPartial, global_size, lastPartial);
//		for (i = 0; i < nmtsks; i++)
//		{
//			printf("%d, ", vSizes[i]);
//		}
//		printf("\n");
//		for (i = 0; i < nmtsks; i++)
//		{
//			printf("%d, ", vDisps[i]);
//		}
//		printf("\n");
//	}

	sort(local_data, 0, local_size-1);

//	int tmpRank = 0;
//	while (tmpRank < nmtsks)
//	{
//		if (tmpRank == rank)
//		{
//			printf("Rank: %d\n", rank);
//			for (i = 0; i < local_size; i++)
//			{
//				printf("%ld, \n", local_data[i]);
//			}
//			printf("\n");
//		}
//		tmpRank++;
//		MPI_Barrier(MPI_COMM_WORLD);
//	}

	MPI_Status status;
	if (nmtsks > 1)
	{
		if (rank == 0)
		{
			for (i = 0; i < local_size; i++)
			{
				global_data[i] = local_data[i];
			}
			for (int mpitask = 1; mpitask < (nmtsks-1); ++mpitask)
			{
				MPI_Recv(&global_data[local_size*mpitask], local_size, MPI_LONG, mpitask, 123, MPI_COMM_WORLD, &status);
			}
			MPI_Recv(&global_data[local_size*(nmtsks-1)], lastPartial, MPI_LONG, nmtsks-1, 123, MPI_COMM_WORLD, &status);
		} else {
			MPI_Send(local_data, local_size, MPI_LONG, 0, 123, MPI_COMM_WORLD);
		}
	}

	if (rank == 0)
	{
		long int tmpMiddle = local_size-1;
		for (i = 1; i < (nmtsks-1); i++)
		{
			//printf("sort %d, middle: %ld, high %ld\n", i, tmpMiddle, tmpMiddle+local_size);
			merge(global_data, 0, tmpMiddle, tmpMiddle+local_size);
			tmpMiddle += local_size;
		}
		merge(global_data, 0, tmpMiddle, global_size-1);
	}

	// output data
	if (rank==0)
	{
		TIMER_STOP;

		if (DEBUG)
		{
			for (i = 0; i < global_size; i++)
			{
				printf("Data: %ld\n", global_data[i]);
			}
		}
		cout << endl;
		cout << "time=" << setprecision(8) <<  TIMER_ELAPSED/1000000.0
			 << " seconds" << endl;
	}

	MPI_Finalize();
	return(0);
}




