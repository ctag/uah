/* 
Christopher Bero
CPE 412
Homework 1 - Problem 2
*/

using namespace std;

#include <iostream>
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

#define NTHREADS 2 /* set number of threads to 8 */

pthread_mutex_t MUTEX; // globaly defined lock variable used to insure
                       // uninterrupted print operations from each thread

struct arg_struct {
	int proc;
	int thread;
};

// PThread - This is the worker thread code
void *hello(void * arg) {
	struct arg_struct *args_p = (struct arg_struct *)arg;

   // enter critical region
   pthread_mutex_lock(&MUTEX);

   cout << "Hello World, from MPI Process " << args_p->proc << " Thread " << args_p->thread << endl << flush;

   // exit critical region
   pthread_mutex_unlock(&MUTEX);

  return arg;
}

int main (int argc, char *argv[]) {
  int tid;                       // tid thread number
  pthread_t threads[NTHREADS];   // holds various thread info 
  int errcode;                   // pthread error code
   MPI_Status status;
   int nmtsks, rank;

   MPI_Init(&argc,&argv); // Initalize MPI environment
   MPI_Comm_size(MPI_COMM_WORLD,&nmtsks); //get total number of processes
   MPI_Comm_rank(MPI_COMM_WORLD,&rank); // get process identity number
   
  //int ids[nmtsks][2];             // holds thread args

	arg_struct args[nmtsks][NTHREADS];
   // initialize mutex variable -- this variable is used to insure that
   // all couts are automic meaning that they are not interrupted
   pthread_mutex_init(&MUTEX,NULL);

   /* create the threads */
   for (tid=0; tid<NTHREADS; tid++) {
	args[rank][tid].proc=rank;
      args[rank][tid].thread=tid;
      errcode=pthread_create(
              &threads[tid],// thread information structure
              NULL,         // thread attributes -- NULL means assume defaults 
              hello,        // function name that is to represent thread
              (void*)&args[rank][tid]);  // pthread created thread id for the created thread        
      // check for error during thread creation
      if (errcode) {
         cerr << "Pthread Creation Error: " << strerror(errcode) << endl << flush; 
         exit(1);
      }
   }

   // wait for all threads to return before exiting main program (process)
   for (tid=0; tid<NTHREADS; tid++) {
      // wait for each thread to terminate 
      errcode=pthread_join(
              threads[tid], //thread scheduler id information of selected thread
              NULL);        //thread return value -- not used in this case
      if (errcode) {
         cerr << "Pthread Join Error: " << strerror(errcode) << endl << flush; 
         exit(1);
      }
   }

  /* Terminate MPI Program -- clear out all buffers */
  MPI_Finalize();

}

