/******************************************************************/
/* Matrix Matrix Multiplication Program Example -- hybrid version */
/* September 2015 -- B. Earl Wells -- University of Alabama       */
/*                                    in Huntsville               */
/******************************************************************/

/**
 * Christopher Bero
 * CPE 412
 * Exam 2 - Problem 3
 */

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

/**
 * headers for an MPI/OMP program
 */
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <omp.h>

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

typedef struct matrix_dimensions
{
	/**
	 * Corresponding:
	 * [l,m] * [m,n] = [l,n]
	 */
	unsigned int l, m, n;
} matrix_dimensions;

/**
 * Generic function which does the same as the definition statements
 */
float * cartesian (float * matrix, int row_sz, int row, int col)
{
	return( (matrix + (row * row_sz) + col) );
}

/*
   Routine to retrieve the data size of the numbers array from the
   command line or by prompting the user for the information
*/
void get_index_size(int argc, char *argv[], unsigned int * tcount, unsigned int *dim_l, unsigned int *dim_m, unsigned int *dim_n)
{
    if(argc!=3 && argc!=5)
    {
        cout<<"usage:  mm_mult_hybrid [thread_count] [l_dimension] <m_dimension n_dimmension>"
            << endl;
        exit(1);
    }
    else
    {
        if (argc == 3)
        {
        	*tcount = atoi(argv[1]);
            *dim_l = *dim_n = *dim_m = atoi(argv[2]);
        }
        else
        {
        	*tcount = atoi(argv[1]);
            *dim_l = atoi(argv[2]);
            *dim_m = atoi(argv[3]);
            *dim_n = atoi(argv[4]);
        }
    }
    if (*dim_l<=0 || *dim_n<=0 || *dim_m<=0 || *tcount <= 0)
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
	pThreads worker commands
*/
void worker (float * local_a, float * b, float * c, unsigned int groupSize, \
			long unsigned int mStart, matrix_dimensions dim, int vDisps[],  int rank, unsigned int * tcount)
{
	int cIndex = 0;
	int i;
	//cout << "rank: " << rank << ", tcount: " << *tcount << endl;
	//fflush(stdout);
	for (i=0; i < groupSize; ++i)
	{
		long unsigned int elem = (mStart + i);
		int a_row = (elem/dim.n);
		int a_row_local= a_row - (vDisps[rank]/dim.m);
		int b_col = (elem % dim.n);

		float dot_prod = 0.0;
		int k;

#		pragma omp parallel for num_threads(*tcount) reduction(+: dot_prod)
		for (k=0; k<dim.m; k++)
		{
			dot_prod += *cartesian(local_a, dim.m, a_row_local, k) * *cartesian(b, dim.n, k, b_col); // A(a_row,k)*B(k,b_col);
		}
		c[cIndex] = dot_prod;
		cIndex++;
	}
}

/*
   MAIN ROUTINE: summation of a number list
*/
int main( int argc, char *argv[])
{
	// Matrix variables
	float *a,*b,*c; 							/* matrix (0,0) address */
	float * local_a;							/* chunk of a to operate on */
    float dot_prod; 							/* dot product result */
    matrix_dimensions dim; 						/* matrix dimensions */
    long unsigned int i,k; 					/* indexes */
	long unsigned int mStart, mEnd; 			/* index of beginning and ending elements for subproblem */
	long unsigned int aCount, bCount, cCount; 	/* Number of elements in matrix */
	unsigned int * tcount;

	// MPI variables
	int nmtsks, rank; 		/* default MPI variables */
	unsigned int groupSize;	/* Number of elements to process */

	/**
	 * MPI initialization
	 */
	MPI_Init(&argc,&argv); 					/* initalize MPI environment */
	MPI_Comm_size(MPI_COMM_WORLD,&nmtsks);	/* find total number of tasks */
	MPI_Comm_rank(MPI_COMM_WORLD,&rank); 	/* get task identity number */

	tcount = new (nothrow) unsigned int;

    /**
     * Process 0 sets up the operands
     */
    if (rank == 0)
	{
		/*
			get matrix sizes AND THREAD COUNT
		*/
		get_index_size(argc,argv,tcount,&dim.l,&dim.m,&dim.n);

		aCount = (dim.l * dim.m);
		bCount = (dim.m * dim.n);
		cCount = (dim.l * dim.n);

		// dynamically allocate from heap the numbers in the memory space
		// for the a,b, and c matrices
		a = new (nothrow) float[dim.l*dim.m];
		b = new (nothrow) float[dim.m*dim.n];
		if(a==0 || b==0)
		{
			cout <<"ERROR:  Insufficient Memory" << endl << flush;
			exit(1);
		}

		/*
		   initialize numbers matrix with random data
		*/
		srand48(SEED);
		fill_matrix(a,dim.l,dim.m);
		fill_matrix(b,dim.m,dim.n);

		/*
		  output numbers matrix
		*/
		if (DEBUG)
		{
			cout << "A matrix =" << endl;
			print_matrix(a,dim.l,dim.m);
			cout << endl;

			cout << "B matrix =" << endl;
			print_matrix(b,dim.m,dim.n);
			cout << endl;
		}

		// Start recording the execution time
		TIMER_CLEAR;
		TIMER_START;
	}

	/**
	 * Disseminate matrix dimensions and operands
	 */
	MPI_Bcast(&dim, (sizeof(dim)/sizeof(unsigned int)), MPI_UNSIGNED, 0, MPI_COMM_WORLD);
	if (rank != 0)
	{
		aCount = (dim.l * dim.m);
		bCount = (dim.m * dim.n);
		cCount = (dim.l * dim.n);
		b = new (nothrow) float[bCount];
		if(b==0)
		{
			cout <<"ERROR:  Insufficient Memory" << endl << flush;
			exit(1);
		}
	}
	MPI_Bcast(b, bCount, MPI_FLOAT, 0, MPI_COMM_WORLD); /* Every process gets a full copy of b */
	MPI_Bcast(tcount, 1, MPI_UNSIGNED, 0, MPI_COMM_WORLD);


	/**
	 * Calculate subproblem indexes
	 */
	groupSize = (cCount / nmtsks);
	mStart = (groupSize * rank);
	mEnd = (mStart + groupSize) - 1;

	/**
	 * If we're the last proc,
	 * extend the group to any missed elements
	 */
	if (rank == (nmtsks-1))
	{
		mEnd = (cCount-1);
		groupSize = (mEnd+1) - mStart;
	}

	/**
	 * Send only rows of matrix a that are needed
	 * A 5000x5000 matrix is 25000000 elements
	 * which with float is 100,000,000 bytes.
	 * I'm suddenly a little memory conscious.
	 *
	 * Need two arrays for scatterv:
	 * - Starting element in matrix a to send
	 * - Length of segment from matrix a to send
	 */
	int vSizes[nmtsks]; /* Size of segment */
	int vDisps[nmtsks]; /* Offset of segment from 0 */
	int elemStart, elemEnd;
	unsigned int rootPartialA = (aCount / nmtsks); /* is the same for rank 0->(n-2) */
	unsigned int lastPartialA = (aCount - (rootPartialA * (nmtsks-1)));
	for (i=0; i<nmtsks; ++i)
	{
		elemStart = ((i*rootPartialA))/dim.m*dim.m;
		if (i == (nmtsks-1))
		{
			elemEnd = ((((i*rootPartialA)-1)+rootPartialA)/dim.m)*dim.m + (dim.m-1);
		} else {
			elemEnd = ((((i*rootPartialA)-1)+lastPartialA)/dim.m)*dim.m + (dim.m-1);
		}
		vSizes[i] = (elemEnd - elemStart) + 1;
		vDisps[i] = (elemStart);
	}

	local_a = new (nothrow) float[vSizes[rank]];
	if(local_a==0)
	{
		cout <<"ERROR:  Insufficient Memory" << endl << flush;
		exit(1);
	}

	MPI_Scatterv(a, vSizes, vDisps, MPI_FLOAT, local_a, vSizes[rank], MPI_FLOAT, 0, MPI_COMM_WORLD);

	/**
	 * Create resulting matrix
	 * Trying to save a little bit of memory on matrix C.
	 */
	if (rank == 0)
	{
		c = new (nothrow) float[dim.l*dim.n];
	}
	else
	{
		c = new (nothrow) float[groupSize];
	}
	if (c == 0)
	{
		cout <<"ERROR:  Insufficient Memory" << endl << flush;
		exit(1);
	}

	// multiply local part of matrix
//	int cIndex = 0;
//	for (i=0; i < groupSize; ++i)
//	{
//		long unsigned int elem = (mStart + i);
//		int a_row = (elem/dim.n);
//		int a_row_local= a_row - (vDisps[rank]/dim.m);
//		int b_col = (elem % dim.n);
//
//		dot_prod = 0.0;
//		for (k=0; k<dim.m; k++)
//		{
//			dot_prod += *cartesian(local_a, dim.m, a_row_local, k) * *cartesian(b, dim.n, k, b_col); // A(a_row,k)*B(k,b_col);
//		}
//		c[cIndex] = dot_prod;
//		cIndex++;
//	}

//void worker (float * local_a, float * b, float * c, unsigned int groupSize, \
//			long unsigned int mStart, matrix_dimensions dim, int vDisps[],  int rank)

	//cout << "MAIN rank: " << rank << ", tcount: " << *tcount << endl;
	worker(local_a, b, c, groupSize, mStart, dim, vDisps, rank, tcount);

	MPI_Status status;
	if (rank == 0)
	{
		for (int mpitask = 1; mpitask < (nmtsks-1); ++mpitask)
		{
			MPI_Recv(&c[groupSize*mpitask], groupSize, MPI_FLOAT, mpitask, 123, MPI_COMM_WORLD, &status);
		}
		MPI_Recv(&c[groupSize*(nmtsks-1)], groupSize+(cCount % nmtsks), MPI_FLOAT, nmtsks-1, 123, MPI_COMM_WORLD, &status);
	} else {
		MPI_Send(c, groupSize, MPI_FLOAT, 0, 123, MPI_COMM_WORLD);
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
		TIMER_STOP;

		if (DEBUG)
		{
			cout << "C matrix =" << endl;
			print_matrix(c,dim.l,dim.n);
		}
		cout << endl;
		cout << "time=" << setprecision(8) <<  TIMER_ELAPSED/1000000.0
			 << " seconds" << endl;
	}

	free(a);
	free(b);
	free(c);
	free(local_a);
	free(tcount);

	MPI_Finalize();

	return(0);
}



