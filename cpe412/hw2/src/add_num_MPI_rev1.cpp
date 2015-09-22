/***************************************************************/
/* Summation of a Sequence of Numbers Program -- MPI version   */
/* July 2015 -- B. Earl Wells -- University of Alabama         */
/*                                    in Huntsville            */
/***************************************************************/
/*
 * add_num_MPI_rev3 - CPE412 - HW2
 * 
This program illustrates the basic concepts of SPMD programming using 
MPI.  The program represents a common example that is used throughout 
the CPE 412/512 text, the distributed addition of a sequence of numbers.
The program is written in such a way that it is assumed that the
sequence of numbers is first read from a central source (such as
a data file) by a single MPI process and then partitioned into equal
groups with each part being distributed (scattered) to the other
MPI processes in the system. After which each process computes its own 
partial sum and send this value to the root process which then
adds the partial sums together (reduce operation) and then
outputs this sum to the screen.

The following is a simplified version of the program which you will
be asked to augment in a number of ways in future homework 
assignments. Use the altix.asc.edu system for these assignments. 

To compile type:

   mpic++ add_num_MPI.cpp -o add_num_MPI

To execute:
   mpirun -np [num MPI process] add_num_MPI [num of numbers] 

Notes: This implementation utilizes a minimum set of MPI function
       call that include MPI_Init, MPI_Finalize, MPI_Comm_size,
       MPI_Comm_rank, MPI_Send, and MPI_Recv.
*/  

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <mpi.h> /* MPI Prototype Header Files */

#define SEED 2397           /* random number seed */
#define MAX_VALUE  100.0    /* maximum value of any number in list */
#define MIN_VALUE  0.0      /* minimum value of any number in list */

/**
 * mms struct
 * Min, Max, Sum
 */
typedef struct mms
{
	double sum;
	double max;
	double min;
}mms;

void printMMS (char* name, mms vals)
{
	printf("\n%s: min: %lf, max: %lf, sum: %lf", name, vals.min, vals.max, vals.sum);
}

/*
ONE-TO-ALL BROADCAST COMMUNICATION ROUTINE
Routine to send from the root MPI process (0) to all other
MPI processes in the system the data whose size given by the
'num_size' parameter. 
*/
int send_all_int(int num_size,int rank,int numtasks)
{
   int mpitask,i,rec_num,type;
   MPI_Status status;

   type = 123;

   /* for root process, rec_num will simply be set to the input */
   /* argument.  It will be overwritten if this is not the      */
   /* root process                                              */
   rec_num=num_size;

   if (rank==0) {
      for(mpitask=1;mpitask<numtasks;mpitask++) {
         MPI_Send(&num_size,1,MPI_INT, 
               mpitask,type,MPI_COMM_WORLD);
      }
   }
   /* if not root process wait to receive number of numbers */
   else {
      MPI_Recv(&rec_num,1,MPI_INT,
               0,type, MPI_COMM_WORLD,&status);
   }

   return rec_num;
}

/*
Routine to retrieve the data size of the numbers array from the 
command line or get this number by prompting the user for the 
information.  Note: command line values are sent to ALL MPI processes
by the MPI environment.
*/
int get_data_size(int argc,char *argv[],int rank,int numtasks)
{
   string input = "";
   int size;

   // ERROR if too many command line arguments
   if(argc > 2) {
      if (rank==0)
         cout << "usage:  mpirun -np [num MPI tasks] add_num_MPI [data size]" << endl;
      MPI_Finalize(); // Terminate MPI
      exit(1); // Exit Program 
   }
   // One Command Line Argument Case:
   // case where user did not enter number of numbers on command line
   // In this case, only one of the MPI processes needs to communicate
   // directly with the user. Since there will always be a MPI process
   // with rank 0 this is the one that will perform the communication.
   if (argc==1) {
      if (rank==0) {
         while (1) {
            cout << "Enter the number of numbers to be added:" << endl;
            getline(cin, input);
            stringstream myStream(input);
            if (myStream >> size) break;
            cout << "Invalid Input" << endl << endl;
         }
      }     
      // since only the root MPI process is communicating with the
      // user, the root process must send its value to all of the
      // other MPI process. It can do this with the send_all_int()
      // broadcast routine.
      size = send_all_int(size,rank,numtasks);
   }
   // Two Command Line Argument case:
   // user supplied the number of numbers on the command line.
   // Each MPI process can retrieve it from there. No need to
   // broadcast it to the other process because each have it at
   // run time.
   else {
      size = atoi(argv[1]);
   }
   return size;
}

/*
Routine that fills the number matrix with Random Data with values
between MIN_VALUE and MAX_VALUE
This simulates in some way what might happen if there was a 
single sequential data acquisition source such as a single file
*/
void fill_matrix(double *numbers,int data_size)
{
   int i;
   srand48(SEED);
   for(i=0;i<data_size;i++) {
      numbers[i]=drand48()*(MAX_VALUE-MIN_VALUE) + MIN_VALUE;
      //to verify may want to initialize the numbers array with a pattern
      //that has a known answer such as the sum of numbers from 0 to N-1
      // The result of that summation is (N+1)*N/2!!
      //numbers[i]=i+10; // to do so uncomment this line
   }
}

/*
Routine that outputs the numbers matrix to the screen 
*/
void print_matrix(double *numbers,int data_size)
{
   int i;
   for(i=0;i<data_size;i++) {
      cout << numbers[i] << endl;
   }
}


/* ONE-TO-ALL SCATTER ROUTINE
Routine to divide and scatter the number data array that resides on the
root MPI process (0) to all other MPI processes in the system.
The number data size is given by the'num_size' parameter its source 
address is given by the '*numbers' parameter, and the destination
group data associated with the current process is given by the
'*group' parameter.  */
void scatter(int num_size,double *numbers,double *group,int rank,int numtasks)
{
   MPI_Status status;
   int i,mpitask,type,group_size,next_group,begin_element;
   type = 234;
   
   /* determine group size */
   group_size = num_size/numtasks;

   /* set up initial beginning element to be start of numbers array */   
   begin_element = group_size;
      
   /* if root process send group data to all processes */ 
   if (rank==0) {
      // in MPI process 0 case just copy portion of data over to the group array
      for (i=0;i<group_size;i++) group[i]=numbers[i];
      /* in other cases perform interprocess communication */
      for(mpitask=1;mpitask<numtasks;mpitask++) {
         /* send group portion of numbers array to other tasks */
         MPI_Send(&numbers[begin_element],group_size,MPI_DOUBLE, 
               mpitask,type,MPI_COMM_WORLD);
         begin_element += group_size;
      }
   }
   /* if a non root process just receive the data */
   else {
      MPI_Recv(group,group_size,MPI_DOUBLE,
               0,type, MPI_COMM_WORLD,&status);  
   }
}
/*
ALL-TO-ONE Reduce ROUTINE
Routine to accumulate the result of the local summation associated
with each MPI process. This routine takes these partial sums and 
produces a global sum on the root MPI process (0)
Input arguments to routine include variable name of local partial
sum of each MPI process. The function returns to MPI root process 0,
the global sum (summation of all partial sums).
*/
//double reduce(double partial_sum,int rank,int numtasks)
mms reduce(mms partial_vals, int rank, int numtasks)
{
	int i, mpitask;
	mms vals, p_vals;
	int type;
	MPI_Status status;
	
	vals.max = MIN_VALUE;
	vals.min = MAX_VALUE;
	
	type = 123;
	vals.sum = partial_vals.sum;
	if (partial_vals.min < vals.min)
	{
		vals.min = partial_vals.min;
	}
	if (partial_vals.max > vals.max)
	{
		vals.max = partial_vals.max;
	}
	// if MPI process 0 sum up results from the other p-1 processes
	if (rank==0) {
		for(mpitask=1;mpitask<numtasks;mpitask++)
		{
			MPI_Recv(&p_vals,3,MPI_DOUBLE,
			mpitask,type,MPI_COMM_WORLD,&status);
			//printMMS("p_vals", p_vals);
			vals.sum += p_vals.sum;
			if (p_vals.min < vals.min)
			{
				vals.min = p_vals.min;
			}
			if (p_vals.max > vals.max)
			{
				vals.max = p_vals.max;
			}
			//printMMS("vals", vals);
		}
	}
	// if not root MPI process 0 then send partial sum to process 0
	else 
	{
		MPI_Send(&partial_vals,3, MPI_DOUBLE, 
		 0, type, MPI_COMM_WORLD);
	}
	return vals;
}

/*
MAIN ROUTINE: summation of numbers in a list
*/

int main( int argc, char *argv[])
{
	double *numbers,*group;

	int data_size,group_size,num_group,i;
	int numtasks,rank,num;
	MPI_Status status;
	mms vals;
	mms pt_vals;
	double sum, pt_sum;
	double max;
	double min;
	
	pt_vals.max = MIN_VALUE;
	pt_vals.min = MAX_VALUE;
	pt_vals.sum =0; // clear out partial sum
	

   MPI_Init(&argc,&argv); // initalize MPI environment
   MPI_Comm_size(MPI_COMM_WORLD,&numtasks); // get total number of MPI processes
   MPI_Comm_rank(MPI_COMM_WORLD,&rank); // get unique task id number 

   //get data size from command line or prompt
   //the user for input
   data_size=get_data_size(argc,argv,rank,numtasks);

   // dynamically allocate from heap the numbers and group arrays
   numbers = new (nothrow) double[data_size];
   group = new (nothrow) double[data_size/numtasks+1];
   if (numbers==0 || group==0) { // check for null pointers
      cout << "Memory Allocation Error" << endl;
      MPI_Finalize(); // Exit MPI
      exit(1); // exit the program
   }
 
   //  if root MPI Process (0) then
   if(rank==0) {
      // initialize numbers matrix with random data
      fill_matrix(numbers,data_size);

      // and print the numbers matrix
      cout << "numbers matrix =" << endl; 
      print_matrix(numbers,data_size);
      cout << endl;
   }
   // scatter the numbers matrix to all processing elements in
   // the system
   scatter(data_size,numbers,group,rank,numtasks);

   // sum up elements in the group associated with the
   // current process
   num_group = data_size/numtasks; // determine local list size 
                                   // group
   
   for (i=0;i<num_group;i++)
   {
	   /*printf("\nrank: %d", rank);
	   printMMS("pt_vals", pt_vals);
	   printf(" group: %lf", group[i]);
	   fflush(stdout);*/
	    pt_vals.sum += group[i];
	    if (group[i] > pt_vals.max)
	    {
			pt_vals.max = group[i];
		}
		if (group[i] < pt_vals.min)
		{
			pt_vals.min = group[i];
		}
   }

   // obtain final sum by summing up partial sums from other MPI tasks/
   vals=reduce(pt_vals,rank,numtasks);

	// output sum from root MPI process
	if (rank==0) 
	{
		cout << endl << "Sum of numbers is " << setprecision(8) << vals.sum;
		cout << endl << "Max of numbers is " << setprecision(8) << vals.max;
		cout << endl << "Min of numbers is " << setprecision(8) << vals.min << endl;
	}

   // reclaim dynamiclly allocated memory
   delete numbers; delete group;

   // Terminate MPI Program -- perform necessary MPI housekeeping
   // clear out all buffers, remove handlers, etc.
   MPI_Finalize();
}

