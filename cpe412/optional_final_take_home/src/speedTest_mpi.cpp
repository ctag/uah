/******************************************************************/
/* Matrix Matrix Multiplication Program Example -- MPI version    */
/* September 2015 -- B. Earl Wells -- University of Alabama       */
/*                                    in Huntsville               */
/******************************************************************/
/**
 * Christopher Bero
 * CPE 412 - Optional Final Exam Problem 2
 * This program is a modification to test node communication speeds
 */

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

/**
 * headers for an MPI program
 */
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>

#define DEBUG false			/* whether to output matrices or not */
#define MX_SZ 320
#define SEED 2397           /* random number seed */
#define MAX_VALUE  100.0    /* maximum size of array elements A, and B */

/* copied from mpbench */
#define TIMER_CLEAR     (tv1.tv_sec = tv1.tv_usec = tv2.tv_sec = tv2.tv_usec = 0)
#define TIMER_START     gettimeofday(&tv1, (struct timezone*)0)
#define TIMER_ELAPSED   ((tv2.tv_usec-tv1.tv_usec)+((tv2.tv_sec-tv1.tv_sec)*1000000))
#define TIMER_STOP      gettimeofday(&tv2, (struct timezone*)0)
struct timeval tv1,tv2;


/*
   Routine to retrieve the data size of the numbers array from the
   command line or by prompting the user for the information
*/
void get_index_size(int argc, char *argv[], long int *dataSize)
{
    if(argc!=2)
    {
        cout<<"usage:  speedTest_mpi [data_size]"
            << endl;
        exit(1);
    }
    else
    {
	*dataSize = atol(argv[1]);
    }
    if (*dataSize<=0)
    {
        cout<<"Error: data size must be greater than 0"
            << endl;
        exit(1);
    }
}

/*
   Routine that fills the number matrix with Random Data with values
   between 0 and MAX_VALUE
   This simulates in some way what might happen if there was a
   single sequential data acquisition source such as a single file
*/
void fill_data(int *array, int aCount)
{
    long int i;
    for(i=0; i<aCount; i++)
    {
       array[i]=lrand48()*MAX_VALUE;
    }
}

/*
   MAIN ROUTINE
*/
int main( int argc, char *argv[])
{
	int *a; 
	long int i, aCount, dataSize;

	// MPI variables
	int nmtsks, rank; 		/* default MPI variables */

	/**
	 * MPI initialization
	 */
	MPI_Init(&argc,&argv); 					/* initalize MPI environment */
	MPI_Comm_size(MPI_COMM_WORLD,&nmtsks);	/* find total number of tasks */
	MPI_Comm_rank(MPI_COMM_WORLD,&rank); 	/* get task identity number */

    /**
     * Process 0 sets up the operands
     */
    if (rank == 0)
	{
		/*
			get matrix sizes
		*/
		get_index_size(argc,argv,&dataSize);

		aCount = (dataSize / sizeof(int)); // Let's just hope this int division turns out OK

		// dynamically allocate from heap the numbers in the memory space
		// for the a,b, and c matrices
		a = new (nothrow) int[aCount];
		if(a==0)
		{
			cout <<"ERROR:  Insufficient Memory" << endl << flush;
			exit(1);
		}

		/*
		   initialize numbers matrix with random data
		*/
		srand48(SEED);
		fill_data(a, aCount);

		/*
		  output data
		*/
		if (DEBUG)
		{
			cout << "A =" << endl;
			for (i=0; i<aCount; i++)
			{
				cout << a[i] << ", ";
			}
			cout << endl;
		}

		// Start recording the execution time
		//TIMER_CLEAR;
		//TIMER_START;
	}

	MPI_Bcast(&aCount, 1, MPI_LONG, 0, MPI_COMM_WORLD);

	if (rank != 0)
	{
		a = new (nothrow) int[aCount];
		if(a==0)
		{
			cout <<"ERROR:  Insufficient Memory" << endl << flush;
			exit(1);
		}
	}

	MPI_Status status;
	if (rank == 0)
	{
		for (int mpitask = 1; mpitask < (nmtsks); ++mpitask)
		{
			TIMER_CLEAR;
			TIMER_START;
			for (i = 0; i < 1000; i++)
			{
				MPI_Send(a, aCount, MPI_INT, mpitask, 123, MPI_COMM_WORLD);
			}
			TIMER_STOP;
			cout << "Sent " << aCount << " int, each " << sizeof(int) 
				<< ", total of " << (aCount * sizeof(int)) << " bytes ";
			cout << "to rank " << mpitask << endl;
			cout << "Time = " << setprecision(8) <<  TIMER_ELAPSED/1000000.0/1000.0 << endl;
		}
	} else {
		for (i = 0; i < 1000; i++)
		{
			MPI_Recv(&a[0], aCount, MPI_INT, 0, 123, MPI_COMM_WORLD, &status);
		}
	}

	/**
	 * Proc 0 outputs results
	 */
	 MPI_Barrier(MPI_COMM_WORLD);
    if (rank == 0)
	{
		/*
		   stop recording the execution time
		*/
		//TIMER_STOP;

		//cout << endl;
		//cout << "time=" << setprecision(8) <<  TIMER_ELAPSED/1000000.0
		//	 << " seconds" << endl;
	}


	MPI_Finalize();

	return(0);
}


