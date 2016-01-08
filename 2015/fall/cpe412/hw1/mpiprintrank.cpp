#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <unistd.h>

using namespace std ;

int main (int argc, char *argv[]) {

   char aline[256];

   ifstream hostname("/etc/HOSTNAME");
   hostname.getline(aline,256);
   hostname.close();

//   MPI_Status status;
//   MPI_Request request;

   int nmtsks, rank;

   MPI_Init(&argc,&argv); /* initalize MPI environment */
   MPI_Comm_size(MPI_COMM_WORLD,&nmtsks);/* find total number of tasks */
   MPI_Comm_rank(MPI_COMM_WORLD,&rank); /* get task identity number */


   MPI_Barrier(MPI_COMM_WORLD);

   sleep(rank); // coordinate IO
   cout << aline << " MPI Rank is " << rank << endl << flush ;

   MPI_Finalize();

  return 0;

}

