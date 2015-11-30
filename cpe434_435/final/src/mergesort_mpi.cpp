/**
 * Christopher Bero
 * CPE 434_435
 * Final Project
 * Parallel Merge Sort
 */

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>
#include <mpi.h>

#define DEBUG false			/* whether to output lists or not */
#define FILES false			/* whether to output to files or not */
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
	//printf("low: %ld, middle: %ld, high: %ld. ", low, middle, high);
	//printf("lsize: %ld, rsize: %ld\n", lsize, rsize);
	long int * ltmp;
	long int * rtmp;
	ltmp = (long int *)malloc(sizeof(long int) * lsize);
	if (ltmp == NULL)
	{
		printf("Error allocating ltmp memory!\n");
		exit(EXIT_FAILURE);
	}
	rtmp = (long int *)malloc(sizeof(long int) * rsize);
	if (rtmp == NULL)
	{
		printf("Error allocating rtmp memory!\n");
		exit(EXIT_FAILURE);
	}
	for (i = 0; i < lsize; i++)
	{
		ltmp[i] = data[low+i];
	}
	for (i = 0; i < rsize; i++)
	{
		rtmp[i] = data[middle+1+i];
	}
	for (dindex = low; dindex <= high; dindex++)
	{
		if (lindex >= lsize)
		{
			//printf("Data #%ld = l>size rtmp [%ld]%ld\n", dindex, rindex, rtmp[rindex]);
			data[dindex] = rtmp[rindex];
			//dindex++;
			rindex++;
			continue;
		}
		if (rindex >= rsize)
		{
			//printf("Data #%ld = r>size ltmp [%ld]%ld\n", dindex, lindex, ltmp[lindex]);
			data[dindex] = ltmp[lindex];
			//dindex++;
			lindex++;
			continue;
		}
		if (ltmp[lindex] < rtmp[rindex])
		{
			//printf("Data #%ld = ltmp [%ld]%ld\n", dindex, lindex, ltmp[lindex]);
			data[dindex] = ltmp[lindex];
			//dindex++;
			lindex++;
		}
		else
		{
			//printf("Data #%ld = rtmp [%ld]%ld\n", dindex, rindex, rtmp[rindex]);
			data[dindex] = rtmp[rindex];
			//dindex++;
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
	printf("data: ");
	for (i = low; i <= high; i++)
	{
		printf("[%ld]%ld, ", i, data[i]);
	}
	printf("\n");
	*/
	free(ltmp);
	free(rtmp);
}

int isdone (long int * data, long int low, long int high)
{
	for (long int i = low; i < high; i++)
	{
		if (data[i] > data[i+1])
			return(0);
	}
	return(1);
}

long int min (long int n1, long int n2)
{
	return (n1<n2) ? n1 : n2;
}

void sort(long int * data, long int size, unsigned int tcount = 1)
{
	// Variables
	long int currentSize, power, powerHigh;
	long int low;
	powerHigh = floor(log2(size));
	//printf("power high: %ld\n", powerHigh);

#	pragma omp parallel for num_threads(tcount)
	for (power=0; power <= powerHigh; power++)
	{
		currentSize = pow(2, power);
		//printf("power: %ld, %ld\n", power, currentSize);
		//printf("Current Size: %ld\n", currentSize);
		for (low=0; low<(size-currentSize); low += 2*currentSize)
		{
			long int middle = (low+currentSize);
			long int high = min(low + (2*currentSize) - 1, size-1);
			//long int middle = ((high - low)/2)+low;
			//printf("currentSize: %ld, low: %ld, middle: %ld, high: %ld.\n", currentSize, low, middle, high);
			merge(data, low, middle-1, high);
			//printf("Merge [%ld:%ld] and [%ld:%ld]\n", low, middle-1, middle, high);
		}
	}
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
	unsigned int *tcount;
	FILE *fp_rand, *fp_sub, *fp_sorted;
	char * sub_name, * sub_rank;
	const char * sub_base = "data/sub_";

	// MPI variables
	int nmtsks, rank; 		/* default MPI variables */

	/**
	 * MPI initialization
	 */
	MPI_Init(&argc,&argv); 					/* initalize MPI environment */
	MPI_Comm_size(MPI_COMM_WORLD,&nmtsks);	/* find total number of tasks */
	MPI_Comm_rank(MPI_COMM_WORLD,&rank); 	/* get task identity number */

	tcount = new (nothrow) unsigned int;
	*tcount = 1;

	/**
	 * Rank 0 sets the stage
	 * collects data size
	 * fills array with random numbers
	 */
	if (rank == 0)
	{
		if (argc != 3)
		{
			printf("Usage: ./mergesort_serial <num_threads> <data_count>");
			exit(EXIT_FAILURE);
		}
		else
		{
			*tcount = (unsigned int)atoi(argv[1]);
			global_size = (long int)atol(argv[2]);
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
			//global_data[i] = (long int)(drand48()*1000.0); // smaller numbers
			global_data[i] = (long int)lrand48();
		}

		// Open output files
		fp_rand = fopen("data/random.txt","w");
		fp_sorted = fopen("data/sorted.txt","w");
		fp_sub = fopen("data/sub.txt", "w");
		fprintf(fp_rand, "# Random Data\n");
		fprintf(fp_sorted, "# Sorted Data\n");
		fprintf(fp_sub, "# Sub-task Sorted Data\n");

		// Write random to files
		for (i = 0; i < global_size; i++)
		{
			fprintf(fp_rand, "%ld\n", global_data[i]);
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

	sort(local_data, local_size, *tcount);

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
			if (FILES)
				fprintf(fp_sub, "Rank: %d\n", rank);
			for (i = 0; i < local_size; i++)
			{
				global_data[i] = local_data[i];
				if (FILES)
					fprintf(fp_sub, "%ld\n", global_data[i]);
			}
			if (FILES)
				fprintf(fp_sub, "\n\n");
			for (int mpitask = 1; mpitask < (nmtsks-1); ++mpitask)
			{
				MPI_Recv(&global_data[local_size*mpitask], local_size, MPI_LONG, mpitask, 123, MPI_COMM_WORLD, &status);
				// Write sub to files
				if (FILES)
				{
					fprintf(fp_sub, "Rank: %d\n", mpitask);
					for (i = 0; i < local_size; i++)
					{
						fprintf(fp_sub, "%ld\n", global_data[(local_size*mpitask)+i]);
					}
					fprintf(fp_sub, "\n\n");
				}
			}
			MPI_Recv(&global_data[local_size*(nmtsks-1)], lastPartial, MPI_LONG, nmtsks-1, 123, MPI_COMM_WORLD, &status);
			// Write sub to files
			if (FILES)
			{
				fprintf(fp_sub, "Rank: %d\n", (nmtsks-1));
				for (i = 0; i < local_size; i++)
				{
					fprintf(fp_sub, "%ld\n", global_data[local_size*(nmtsks-1)+i]);
				}
				fprintf(fp_sub, "\n\n");
			}
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

		// Write sorted to files
		if (FILES)
		{
			for (i = 0; i < global_size; i++)
			{
				fprintf(fp_sorted, "%ld\n", global_data[i]);
			}
		}

		fclose(fp_rand);
		fclose(fp_sorted);
		fclose(fp_sub);

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



