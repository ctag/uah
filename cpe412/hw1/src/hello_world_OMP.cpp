/*
openMP Example - Hello World - C/C++ Version
FILE: hello_world_OMP.cpp

Compilation on dmc.asc.edu

  first set up environment by typing from the command line the
  following two module load commands
   module load intel

   to set number of threads through environment variable in bash shell
   (have to do this before you run the program)
   export OMP_NUM_THREADS=8 

   to compile the program

      icc -o hello_world_OMP -openmp hello_world_OMP.cpp

   to run -- set number of threads as explained above and then type

     ./hello_world_OMP  

*/

using namespace std;
#include <iostream>
#include <omp.h>

int main (int argc, char *argv[]) {

   // Create a Team of threads 
   #pragma omp parallel
   {
      int nthreads, tid; // Thread Private Variables

      // Obtain thread number
      tid = omp_get_thread_num();

      // print out Hello World Message -- do this as a noninterruptable op
      #pragma omp critical
      {
         cout << "Hello World from thread = " << tid << endl << flush;
      }
      // get number of threads
      nthreads = omp_get_num_threads();

      // print out No of Threads Message -- do this as a noninterruptable op
      #pragma omp critical
      {
         // Only master thread does this
         if (tid == 0) {
            cout << "Number of Threads = "  << nthreads << endl << flush;
         }
      }
   }  // All threads join master thread and disband 

}

