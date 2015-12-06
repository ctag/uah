/**
 * Christopher Bero
 * CPE 434_435
 * Final Project
 * Serial Merge Sort - Recursive
 */

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <stdio.h>

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
    long int i; 					/* indexes */
	long int *rdata; /* random array */
	long int data_size;

	// Collect arguments
	if (argc != 2)
	{
		printf("Usage: ./mergesort_serial <data_count>");
		return(-1);
	}
	else
	{
		data_size = (long int)atol(argv[1]);
	}

	// Instantiate memory
	//rdata = new long int[data_size];
	rdata = (long int*)malloc(sizeof(long int) * data_size);
	if (!rdata)
	{
		printf("Memory allocation failed. \n");
		exit(EXIT_FAILURE);
	}

	// Generate psudorandom data
	srand48(SEED);
	for (i = 0; i < data_size; i++)
	{
		rdata[i] = (long int)lrand48();
	}

	// output data
	if (DEBUG)
	{
		for (i = 0; i < data_size; i++)
		{
			printf("Data: %ld\n", rdata[i]);
		}
		printf("\n");
	}

	TIMER_CLEAR;
	TIMER_START;

	sort(rdata, 0, data_size-1);

	TIMER_STOP;

	// output data
	if (DEBUG)
	{
		for (i = 0; i < data_size; i++)
		{
			printf("Data: %ld\n", rdata[i]);
		}
	}

	cout << endl;
	cout << "time=" << setprecision(8) <<  TIMER_ELAPSED/1000000.0
		 << " seconds" << endl;


//	// MPI variables
//	int nmtsks, rank; 		/* default MPI variables */
//	unsigned int groupSize;	/* Number of elements to process */
//
//	/**
//	 * MPI initialization
//	 */
//	MPI_Init(&argc,&argv); 					/* initalize MPI environment */
//	MPI_Comm_size(MPI_COMM_WORLD,&nmtsks);	/* find total number of tasks */
//	MPI_Comm_rank(MPI_COMM_WORLD,&rank); 	/* get task identity number */
//
//	tcount = new (nothrow) unsigned int;
//
//    /**
//     * Process 0 sets up the operands
//     */
//    if (rank == 0)
//	{
//		/*
//			get matrix sizes AND THREAD COUNT
//		*/
//		get_index_size(argc,argv,tcount,&dim.l,&dim.m,&dim.n);
//
//		aCount = (dim.l * dim.m);
//		bCount = (dim.m * dim.n);
//		cCount = (dim.l * dim.n);
//
//		// dynamically allocate from heap the numbers in the memory space
//		// for the a,b, and c matrices
//		a = new (nothrow) float[dim.l*dim.m];
//		b = new (nothrow) float[dim.m*dim.n];
//		if(a==0 || b==0)
//		{
//			cout <<"ERROR:  Insufficient Memory" << endl << flush;
//			exit(1);
//		}
//
//		/*
//		   initialize numbers matrix with random data
//		*/
//		srand48(SEED);
//		fill_matrix(a,dim.l,dim.m);
//		fill_matrix(b,dim.m,dim.n);
//
//		/*
//		  output numbers matrix
//		*/
//		if (DEBUG)
//		{
//			cout << "A matrix =" << endl;
//			print_matrix(a,dim.l,dim.m);
//			cout << endl;
//
//			cout << "B matrix =" << endl;
//			print_matrix(b,dim.m,dim.n);
//			cout << endl;
//		}
//
//		// Start recording the execution time
//		TIMER_CLEAR;
//		TIMER_START;
//	}
//
//	/**
//	 * Disseminate matrix dimensions and operands
//	 */
//	MPI_Bcast(&dim, (sizeof(dim)/sizeof(unsigned int)), MPI_UNSIGNED, 0, MPI_COMM_WORLD);
//	if (rank != 0)
//	{
//		aCount = (dim.l * dim.m);
//		bCount = (dim.m * dim.n);
//		cCount = (dim.l * dim.n);
//		b = new (nothrow) float[bCount];
//		if(b==0)
//		{
//			cout <<"ERROR:  Insufficient Memory" << endl << flush;
//			exit(1);
//		}
//	}
//	MPI_Bcast(b, bCount, MPI_FLOAT, 0, MPI_COMM_WORLD); /* Every process gets a full copy of b */
//	MPI_Bcast(tcount, 1, MPI_UNSIGNED, 0, MPI_COMM_WORLD);
//
//
//
//	/**
//	 * Calculate subproblem indexes
//	 */
//	groupSize = (cCount / nmtsks);
//	mStart = (groupSize * rank);
//	mEnd = (mStart + groupSize) - 1;
//
//	/**
//	 * If we're the last proc,
//	 * extend the group to any missed elements
//	 */
//	if (rank == (nmtsks-1))
//	{
//		mEnd = (cCount-1);
//		groupSize = (mEnd+1) - mStart;
//	}
//
//	/**
//	 * Send only rows of matrix a that are needed
//	 * A 5000x5000 matrix is 25000000 elements
//	 * which with float is 100,000,000 bytes.
//	 * I'm suddenly a little memory conscious.
//	 *
//	 * Need two arrays for scatterv:
//	 * - Starting element in matrix a to send
//	 * - Length of segment from matrix a to send
//	 */
//	int vSizes[nmtsks]; /* Size of segment */
//	int vDisps[nmtsks]; /* Offset of segment from 0 */
//	int elemStart, elemEnd;
//	unsigned int rootPartialA = (aCount / nmtsks); /* is the same for rank 0->(n-2) */
//	unsigned int lastPartialA = (aCount - (rootPartialA * (nmtsks-1)));
//	for (i=0; i< (unsigned int)nmtsks; ++i)
//	{
//		elemStart = ((i*rootPartialA))/dim.m*dim.m;
//		if (i == (unsigned int)(nmtsks-1))
//		{
//			elemEnd = ((((i*rootPartialA)-1)+rootPartialA)/dim.m)*dim.m + (dim.m-1);
//		} else {
//			elemEnd = ((((i*rootPartialA)-1)+lastPartialA)/dim.m)*dim.m + (dim.m-1);
//		}
//		vSizes[i] = (elemEnd - elemStart) + 1;
//		vDisps[i] = (elemStart);
//	}
//
//	local_a = new (nothrow) float[vSizes[rank]];
//	if(local_a==0)
//	{
//		cout <<"ERROR:  Insufficient Memory" << endl << flush;
//		exit(1);
//	}
//
//	MPI_Scatterv(a, vSizes, vDisps, MPI_FLOAT, local_a, vSizes[rank], MPI_FLOAT, 0, MPI_COMM_WORLD);
//
//	/**
//	 * Create resulting matrix
//	 * Trying to save a little bit of memory on matrix C.
//	 */
//	if (rank == 0)
//	{
//		c = new (nothrow) float[dim.l*dim.n];
//	}
//	else
//	{
//		c = new (nothrow) float[groupSize];
//	}
//	if (c == 0)
//	{
//		cout <<"ERROR:  Insufficient Memory" << endl << flush;
//		exit(1);
//	}
//
//	//cout << "MAIN rank: " << rank << ", tcount: " << *tcount << endl;
//	worker(local_a, b, c, groupSize, mStart, dim, vDisps, rank, tcount);
//
//	MPI_Status status;
//	if (nmtsks > 1)
//	{
//		if (rank == 0)
//		{
//			for (int mpitask = 1; mpitask < (nmtsks-1); ++mpitask)
//			{
//				MPI_Recv(&c[groupSize*mpitask], groupSize, MPI_FLOAT, mpitask, 123, MPI_COMM_WORLD, &status);
//			}
//			MPI_Recv(&c[groupSize*(nmtsks-1)], groupSize+(cCount % nmtsks), MPI_FLOAT, nmtsks-1, 123, MPI_COMM_WORLD, &status);
//		} else {
//			MPI_Send(c, groupSize, MPI_FLOAT, 0, 123, MPI_COMM_WORLD);
//		}
//	}
//
//	/**
//	 * Proc 0 outputs results
//	 */
//	 MPI_Barrier(MPI_COMM_WORLD);
//    if (rank == 0)
//	{
//		/*
//		   stop recording the execution time
//		*/
//		TIMER_STOP;
//
//		if (DEBUG)
//		{
//			cout << "C matrix =" << endl;
//			print_matrix(c,dim.l,dim.n);
//		}
//		cout << endl;
//		cout << "time=" << setprecision(8) <<  TIMER_ELAPSED/1000000.0
//			 << " seconds" << endl;
//	}
//
//	MPI_Finalize();

	return(0);
}



