/*
  Pthreads Example - Hello World - C/C++ Version
  File: hello_world_PTH.cpp

  first set up environment by typing from the command line the
  following module load command
     module load intel

  Compilation on dmc.asc.edu
     to compile the program
         icc hello_world_PTH.cpp -o hello_world_PTH -lpthread
     to run type
       ./hello_world_PTH
*/

using namespace std;
#include <iostream>

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

#define NTHREADS 8 /* set number of threads to 8 */

pthread_mutex_t MUTEX; // globaly defined lock variable used to insure
                       // uninterrupted print operations from each thread

// This is the worker thread code
void *hello(void * arg) {
   int myid=*(int *) arg;

   // enter critical region
   pthread_mutex_lock(&MUTEX);

   cout << "Hello World, from PThread " << myid << endl << flush;

   // exit critical region
   pthread_mutex_unlock(&MUTEX);

  return arg;
}

// this is the main thread's code -- it spawns the worker threads and
// then waits for all the worker threads to return before it exits
int main(int argc,char *argv[])
{
  int tid;                       // tid thread number
  pthread_t threads[NTHREADS];   // holds various thread info 
  int ids[NTHREADS];             // holds thread args
  int errcode;                   // pthread error code

   // initialize mutex variable -- this variable is used to insure that
   // all couts are automic meaning that they are not interrupted
   pthread_mutex_init(&MUTEX,NULL);

   /* create the threads */
   for (tid=0; tid<NTHREADS; tid++) {
      ids[tid]=tid;
      errcode=pthread_create(
              &threads[tid],// thread information structure
              NULL,         // thread attributes -- NULL means assume defaults 
              hello,        // function name that is to represent thread
              &ids[tid]);  // pthread created thread id for the created thread        
      // check for error during thread creation
      if (errcode) {
         cerr << "Pthread Creation Error: " << strerror(errcode) << endl << flush; 
         exit(1);
      }
   }

   // print out number of threads
   pthread_mutex_lock(&MUTEX); // enter critical region
   cout << "Number of threads = " << NTHREADS << endl << flush;
   pthread_mutex_unlock(&MUTEX); // exit critical region

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
   return(0);
}
