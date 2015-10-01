/******************************************************************/
/* Matrix Matrix Multiplication Program Example -- MPI version    */
/* September 2015 -- B. Earl Wells -- University of Alabama       */
/*                                    in Huntsville               */
/******************************************************************/
/*
   This program is designed to perform matrix matrix multiplication
   A x B = C, where A is an lxm matrix, B is a m x n matrix and
   C is a l x n matrix. The program is designed to be a template
   serial program that can be expanded into a parallel multiprocess
   and/or a multi-threaded program.

   The program randomly assigns the elements of the A and B matrix
   with values between 0 and a MAX_VALUE. It then multiples the
   two matrices with the result being placed in the C matrix.
   The program prints out the A, B, and C matrices.

   The program is executed using one or three command line parameters.
   These parameters represent the dimension of the matrices. If only
   one parameter is used then then it is assumed that square matrices are
   to be created and multiplied together that have the specified
   dimension. In cases where three command line parameters are entered
   then the first parameter is the l dimension, the second the m, and
   the third is the n dimension.

   To execute:
   mm_mult_serial [l_parameter] <m_parameter n_parameter>
*/

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

/**
 * Added headers for an MPI program
 */
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>

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
This declaration facilitates the creation of two dimensional
dynamically allocated arrays (i.e. the lxm A array, the mxn B
array, and the lxn C array).  It allows pointer arithmetic to
be applied to a single data stream that can be dynamically allocated.
To address the element at row x, and column y you would use the
following notation:  A(x,y),B(x,y), or C(x,y), respectively.
Note that this differs from the normal C notation if A were a
two dimensional array of A[x][y] but is still very descriptive
of the data structure.
*/
float *a,*b,*c;
#define A(i,j) *(a+((i*dim_m)+j))
#define B(i,j) *(b+((i*dim_n)+j))
#define C(i,j) *(c+((i*dim_n)+j))

/*
   Routine to retrieve the data size of the numbers array from the
   command line or by prompting the user for the information
*/
void get_index_size(int argc,char *argv[],int *dim_l,int *dim_m,int *dim_n)
{
    if(argc!=2 && argc!=4)
    {
        cout<<"usage:  mm_mult_serial [l_dimension] <m_dimension n_dimmension>"
            << endl;
        exit(1);
    }
    else
    {
        if (argc == 2)
        {
            *dim_l = *dim_n = *dim_m = atoi(argv[1]);
        }
        else
        {
            *dim_l = atoi(argv[1]);
            *dim_m = atoi(argv[2]);
            *dim_n = atoi(argv[3]);
        }
    }
    if (*dim_l<=0 || *dim_n<=0 || *dim_m<=0)
    {
        cout<<"Error: number of rows and/or columns must be greater than 0"
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
void fill_matrix(float *array,int dim_m,int dim_n)
{
    int i,j;
    for(i=0; i<dim_m; i++)
    {
        for (j=0; j<dim_n; j++)
        {
            array[i*dim_n+j]=drand48()*MAX_VALUE;
        }
    }
}

/*
   Routine that outputs the matrices to the screen
*/
void print_matrix(float *array,int dim_m,int dim_n)
{
    int i,j;
    for(i=0; i<dim_m; i++)
    {
        for (j=0; j<dim_n; j++)
        {
            cout << array[i*dim_n+j] << " ";
        }
        cout << endl;
    }
}

/*
   MAIN ROUTINE: summation of a number list
*/
int main( int argc, char *argv[])
{
    float dot_prod; /* dot product result */
    int dim_l,dim_n,dim_m; /* matrix dimensions */
    long unsigned int i,j,k; /* indexes */
	int nmtsks, rank; /* default MPI variables */
	long unsigned int mStart, mEnd; /* index of beginning and ending elements */
	unsigned int groupSize; /* Number of elements to process, minus -1's */
	long unsigned int aElems, bElems, cElems; /* Number of elements in matrix */

	/**
	 * MPI initialization
	 */
	MPI_Init(&argc,&argv); /* initalize MPI environment */
	MPI_Comm_size(MPI_COMM_WORLD,&nmtsks);/* find total number of tasks */
	MPI_Comm_rank(MPI_COMM_WORLD,&rank); /* get task identity number */

    /**
     * Process 0 sets up the operands
     */
    if (rank == 0)
	{
		/*
			get matrix sizes
		*/
		get_index_size(argc,argv,&dim_l,&dim_m,&dim_n);

		// dynamically allocate from heap the numbers in the memory space
		// for the a,b, and c matrices
		a = new (nothrow) float[dim_l*dim_m];
		b = new (nothrow) float[dim_m*dim_n];

		if(a==0 || b==0)
		{
			cout <<"ERROR:  Insufficient Memory" << endl;
			exit(1);
		}

		/*
		   initialize numbers matrix with random data
		*/
		srand48(SEED);
		fill_matrix(a,dim_l,dim_m);
		fill_matrix(b,dim_m,dim_n);

		/*
		  output numbers matrix
		*/
		/*cout << "A matrix =" << endl;
		print_matrix(a,dim_l,dim_m);
		cout << endl;

		cout << "B matrix =" << endl;
		print_matrix(b,dim_m,dim_n);
		cout << endl;*/
	}

	/*
    Start recording the execution time
    */
    if (rank == 0)
	{
		TIMER_CLEAR;
		TIMER_START;
	}

	/**
	 * Disseminate matrix dimensions and operands
	 */
	MPI_Bcast(&dim_l, 1, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Bcast(&dim_m, 1, MPI_INT, 0, MPI_COMM_WORLD);
	MPI_Bcast(&dim_n, 1, MPI_INT, 0, MPI_COMM_WORLD);
	aElems = (dim_l * dim_m);
	bElems = (dim_m * dim_n);
	cElems = (dim_l * dim_n);
	if (rank != 0)
	{
		a = new (nothrow) float[aElems];
		b = new (nothrow) float[bElems];
	}
	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Bcast(a, aElems, MPI_FLOAT, 0, MPI_COMM_WORLD);
	MPI_Bcast(b, bElems, MPI_FLOAT, 0, MPI_COMM_WORLD);

	/**
	 * Calculate subproblem indexes
	 */
	groupSize = (cElems / nmtsks);
	mStart = (groupSize * rank);
	mEnd = (mStart + groupSize) - 1;

	/**
	 * If we're the last proc,
	 * extend the group to any missed elements
	 */
	if (rank == (nmtsks-1))
	{
		mEnd = (cElems-1);
		groupSize = (mEnd+1) - mStart;
	}

	/**
	 * Create resulting matrix
	 * Trying to save a little bit of memory on C.
	 * I would rather have avoided pushing all of A and B
	 * to each process. Oh well.
	 */
	if (rank == 0)
	{
		c = new (nothrow) float[dim_l*dim_n];
	}
	else
	{
		c = new (nothrow) float[groupSize];
	}
	if (c == 0)
	{
		cout <<"ERROR:  Insufficient Memory" << endl;
		exit(1);
	}

//	cout << flush;
//	MPI_Barrier(MPI_COMM_WORLD);
//	sleep(rank); // coordinate IO
//
//	cout << " MPI Rank is " << rank
//	<< " group: " << groupSize
//	<< " start: " << mStart
//	<< " end: " << mEnd
//	<< endl << flush ;

	// multiply local part of matrix
    // i -> dim_l
    //  j -> dim_n
    //   k -> dim_m
	int cIndex = 0;
	for (i=0; i < groupSize; ++i)
	{
		long unsigned int elem = (mStart + i);
		int a_row = (elem / dim_n);
		int b_col = (elem % dim_n);
		dot_prod = 0.0;
		for (k=0; k<dim_m; k++)
		{
			dot_prod += A(a_row,k)*B(k,b_col);
		}
		c[cIndex] = dot_prod;
		cIndex++;
	}

//	cout << flush;
//    MPI_Barrier(MPI_COMM_WORLD);
//   sleep(rank); // coordinate IO
//
//	cout << endl
//		<< "I am " << rank
//		<< " C = " << endl;
//    for (i = 0; i < groupSize; ++i)
//	{
//		cout << c[i] << ", ";
//	}
//	cout << flush;
//
//	MPI_Finalize();
//	return(0);

	MPI_Status status;
	if (rank == 0)
	{
		for (int mpitask = 1; mpitask < (nmtsks-1); ++mpitask)
		{
			MPI_Recv(&c[groupSize*mpitask], groupSize, MPI_FLOAT, mpitask, 123, MPI_COMM_WORLD, &status);
		}
		MPI_Recv(&c[groupSize*(nmtsks-1)], groupSize+(cElems % nmtsks), MPI_FLOAT, nmtsks-1, 123, MPI_COMM_WORLD, &status);
	} else {
		MPI_Send(c, groupSize, MPI_FLOAT, 0, 123, MPI_COMM_WORLD);
	}

	/**
	 * Proc 0 outputs results
	 */
    if (rank == 0)
	{
		/*
		   stop recording the execution time
		*/
		TIMER_STOP;

		/*cout << "C matrix =" << endl;
		print_matrix(c,dim_l,dim_n);*/
		cout << endl;
		cout << "time=" << setprecision(8) <<  TIMER_ELAPSED/1000000.0
			 << " seconds" << endl;
	}


	MPI_Finalize();

	return(0);
}


