-----------------------------------------------------------
Getting started with the tutorial code
-----------------------------------------------------------

We provide a very simply sample code to help get you up and running with MPI.
This application is equivalent to the standard "Hello world" program covered in
any intro programming class, but provides the basic structure to walk you
through the steps of compiling and running an MPI application on the DMC.

First, you'll want to copy the mpiprintrank tutorial code to your home
directory:

cp -R /opt/asn/doc/mpi/mpi_example/mpiprintrank $HOME/


-----------------------------------------------------------
Compiling the tutorial code on the DMC
-----------------------------------------------------------

This tutorial assumes you're logged into the DMC.

First, make sure you're logged into the DMC.  Your prompt should probably have
dmc in it somewhere and shouldn't say uv.  Then you should type the following
(assuming you've already copied to code to your home directory).

cd $HOME/mpiprintrank
module load openmpi
make dmc

This will compile our sample MPI application for the DMC using the latest
OpenMPI and the Intel compiler.  You should get a resulting binary called
mpiprintrank-dmc.


-----------------------------------------------------------
Running the tutorial code through the queue system
-----------------------------------------------------------

To run this compiled binary through the queue system, you'll first need to
write a script that loads the necessary MPI environment module and then
launches your code with mpiexec.  An example script has been provided called
dmc-mpi.sh.  This script may need to be adjusted if you used a different MPI
than that used above when you compiled your code.

Make sure the script is executable like this:

chmod +x dmc-mpi.sh

Submit it to the queue with a command like this:

run_script_mpi dmc-mpi.sh

This will ask you which queue, how many processors, how much memory, etc.
Generally anything you choose for these will work for this tutorial, but be
sure to specify that your job must run on the DMC.  The binary you generated
earlier will only work on the DMC and will not work on the UV.

Once your job has completed, you should find an output file with something
similar to the following (in this case, we asked for 4 cpus and ended up
getting one each from dmc65 through dmc68):

dmc65.asc.edu MPI Rank is 0
dmc66.asc.edu MPI Rank is 1
dmc67.asc.edu MPI Rank is 2
dmc68.asc.edu MPI Rank is 3


