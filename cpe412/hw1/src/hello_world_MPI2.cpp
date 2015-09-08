/* 
   MPI Example - Hello World - C++ Version
   using the full C++ syntax
   FILE: hello_world_MPI2.cpp

   Compilation on dmc.asc.edu

   first set up environment by typing from the command line

      module load openmpi

   to compile the program type

      mpic++ hello_world_MPI2.cpp -o hello_world_MPI2 

   to run on eight processors type

      mpirun -np 8 ./hello_world_MPI2
*/

using namespace std;
#include <iostream>
#include <mpi.h>

int main (int argc, char *argv[]) {
   MPI_Status status;
   int nmtsks, rank;

   MPI::Init(argc,argv); // Initalize MPI environment

   nmtsks=MPI::COMM_WORLD.Get_size(); //get total number of processes

   rank= MPI::COMM_WORLD.Get_rank(); // get process identity number

   cout << "Hello World from MPI Process #" << rank << endl << flush;

   /* Only root MPI process does this */
   if (rank == 0) {
     cout << "Number of MPI Processes = " << nmtsks << endl;
   }

  /* Terminate MPI Program -- clear out all buffers */
  MPI::Finalize();

}
