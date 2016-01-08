#!/bin/bash
# MPI speed job

mpirun -np 6 -pernode ../bin/speedTest_mpi 16384 > ../output/speedTest_mpi_1.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 32768 > ../output/speedTest_mpi_2.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 65536 > ../output/speedTest_mpi_3.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 131072 > ../output/speedTest_mpi_4.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 262144 > ../output/speedTest_mpi_5.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 524288 > ../output/speedTest_mpi_6.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 1048576 > ../output/speedTest_mpi_7.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 2097152 > ../output/speedTest_mpi_8.txt
mpirun -np 6 -pernode ../bin/speedTest_mpi 4194304 > ../output/speedTest_mpi_9.txt


