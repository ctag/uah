/******************************************************************/
/* Matrix Matrix Multiplication Program Example - pthread version */
/* September 2015 -- B. Earl Wells -- University of Alabama       */
/*                                    in Huntsville               */
/* Modified base program - Chris Bero */
/******************************************************************/
/**
 * Christopher Bero
 * CPE 412 - HW4
 * This program is a modification of mm_mult_serial.cpp
 */

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <pthread.h>

#define DEBUG 0

#define MX_SZ 320
#define SEED 2397           /* random number seed */
#define MAX_VALUE  100.0    /* maximum size of array elements A, and B */

/* copied from mpbench */
#define TIMER_CLEAR     (tv1.tv_sec = tv1.tv_usec = tv2.tv_sec = tv2.tv_usec = 0)
#define TIMER_START     gettimeofday(&tv1, (struct timezone*)0)
#define TIMER_ELAPSED   ((tv2.tv_usec-tv1.tv_usec)+((tv2.tv_sec-tv1.tv_sec)*1000000))
#define TIMER_STOP      gettimeofday(&tv2, (struct timezone*)0)
struct timeval tv1,tv2;

typedef struct tdata
{
	float * a;
	float * b;
	float * c;
	int * dim_l;
	int * dim_n;
	int * dim_m;
	int * tcount;
	int tid;
} tdata;

/*
This declaration facilitates the creation of a two dimensional
dynamically allocated arrays (i.e. the lxm A array, the mxn B
array, and the lxn C array).  It allows pointer arithmetic to
be applied to a single data stream that can be dynamically allocated.
To address the element at row x, and column y you would use the
following notation:  A(x,y),B(x,y), or C(x,y), respectively.
Note that this differs from the normal C notation if A were a
two dimensional array of A[x][y] but is still very descriptive
of the data structure.
#define A(i,j) *(a+i*dim_m+j)
#define B(i,j) *(b+i*dim_n+j)
#define C(i,j) *(c+i*dim_n+j)
*/

#define A(i,j) *(data->a+i*(*data->dim_m)+j)
#define B(i,j) *(data->b+i**data->dim_n+j)
#define C(i,j) *(data->c+i**data->dim_n+j)

/*
   Routine to retrieve the data size of the numbers array from the
   command line or by prompting the user for the information
*/
void get_index_size(int argc,char *argv[],int * tcount,int *dim_l,int *dim_m,int *dim_n) {
   if(argc!=3 && argc!=5) {
      cout<<"usage:  mm_mult_serial [thread count] [l_dimension] <m_dimension n_dimmension>"
           << endl;
      exit(1);
   }
   else {
      if (argc == 3) {
		*tcount = atoi(argv[1]);
         *dim_l = *dim_n = *dim_m = atoi(argv[2]);
      }
      else {
      	*tcount = atoi(argv[1]);
         *dim_l = atoi(argv[2]);
         *dim_m = atoi(argv[3]);
         *dim_n = atoi(argv[4]);
      }
   }
   if (*tcount<= 0 || *dim_l<=0 || *dim_n<=0 || *dim_m<=0) {
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
   for(i=0;i<dim_m;i++) {
      for (j=0;j<dim_n;j++) {
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
   for(i=0;i<dim_m;i++) {
      for (j=0;j<dim_n;j++) {
         cout << array[i*dim_n+j] << " ";
      }
      cout << endl;
   }
}

void * twork (void * args)
{
	float dot_prod;
	int i, j, k;
	int row_start, row_stop;
	tdata * data = (tdata*)args;

	// Not an elegant solution, but a fast one to implement
	row_start = (*data->dim_l / *data->tcount) * data->tid;
	row_stop = (*data->dim_l / *data->tcount) * (data->tid + 1);
	if (data->tid == (*data->tcount-1))
	{
		row_stop = *data->dim_l;
	}

	//printf("\nWorking: %d, start: %d, stop: %d.", data->tid, row_start, row_stop);
	//fflush(stdout);

	for (i=row_start;i<row_stop;i++) {
	  for (j=0;j<*data->dim_n;j++) {
		 dot_prod = 0.0;
		 for (k=0;k<*data->dim_m;k++) {
			dot_prod += A(i,k)*B(k,j);
		 }
		 C(i,j) = dot_prod;
	  }
	}

	return (NULL);
}

/*
   MAIN ROUTINE: summation of a number list
*/
int main( int argc, char *argv[])
{
   int dim_l,dim_n,dim_m;
   int i;
   float *a,*b,*c;
   int tcount;
   pthread_t * tids;
   tdata * tdatas;

   /*
   get matrix sizes AND THREAD COUNT
   */
   get_index_size(argc,argv,&tcount,&dim_l,&dim_m,&dim_n);

   // dynamically allocate from heap the numbers in the memory space
   // for the a,b, and c matrices
   a = new (nothrow) float[dim_l*dim_m];
   b = new (nothrow) float[dim_m*dim_n];
   c = new (nothrow) float[dim_l*dim_n];
   tids = new (nothrow) pthread_t[tcount];
   tdatas = new (nothrow) tdata[tcount];
   if(a==0 || b==0 || c==0 || tids==0) {
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
   if (DEBUG)
   {
   cout << "A matrix =" << endl;
   print_matrix(a,dim_l,dim_m);
   cout << endl;

   cout << "B matrix =" << endl;
   print_matrix(b,dim_m,dim_n);
   cout << endl;
   }

   /*
   Start recording the execution time
   */
   TIMER_CLEAR;
   TIMER_START;

	for (i=0; i<tcount; ++i)
	{
		tdatas[i].a = a;
		tdatas[i].b = b;
		tdatas[i].c = c;
		tdatas[i].dim_l = &dim_l;
		tdatas[i].dim_n = &dim_n;
		tdatas[i].dim_m = &dim_m;
		tdatas[i].tid = i;
		tdatas[i].tcount = &tcount;
		pthread_create(&tids[i], NULL, twork, &tdatas[i]);
	}

	for (i=0; i<tcount; ++i)
	{
		pthread_join(tids[i], NULL);
	}

   // multiply local part of matrix
   /*
   for (i=0;i<dim_l;i++) {
      for (j=0;j<dim_n;j++) {
         dot_prod = 0.0;
         for (k=0;k<dim_m;k++) {
            dot_prod += A(i,k)*B(k,j);
         }
         C(i,j) = dot_prod;
      }
   }
   */

   /*
      stop recording the execution time
   */
   TIMER_STOP;

   if (DEBUG)
   {
   cout << "C matrix =" << endl;
   print_matrix(c,dim_l,dim_n);
   cout << endl;
   }
   cout << "time=" << setprecision(8) <<  TIMER_ELAPSED/1000000.0
        << " seconds" << endl;

}


