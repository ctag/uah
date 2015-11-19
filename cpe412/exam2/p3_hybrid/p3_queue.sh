#!/bin/bash


#module load openmpi
module load openmpi/1.10.1-gnu

mpiexec -np 2 ./bin/mm_mult_hybrid 4 5000 5000 5000 > mm_mult_hybrid_2.txt
#mpirun -np 2 ./bin/mm_mult_hybrid 4 5000 5000 5000 >> mm_mult_hybrid_2.txt
#mpirun -np 2 ./bin/mm_mult_hybrid 4 5000 5000 5000 >> mm_mult_hybrid_2.txt
#mpirun -np 2 ./bin/mm_mult_hybrid 4 5000 5000 5000 >> mm_mult_hybrid_2.txt
#mpirun -np 2 ./bin/mm_mult_hybrid 4 5000 5000 5000 >> mm_mult_hybrid_2.txt
#
#mpirun -np 4 ./bin/mm_mult_hybrid 2 5000 5000 5000 > mm_mult_hybrid_4.txt
#mpirun -np 4 ./bin/mm_mult_hybrid 2 5000 5000 5000 >> mm_mult_hybrid_4.txt
#mpirun -np 4 ./bin/mm_mult_hybrid 2 5000 5000 5000 >> mm_mult_hybrid_4.txt
#mpirun -np 4 ./bin/mm_mult_hybrid 2 5000 5000 5000 >> mm_mult_hybrid_4.txt
#mpirun -np 4 ./bin/mm_mult_hybrid 2 5000 5000 5000 >> mm_mult_hybrid_4.txt
#
#mpirun -np 8 ./bin/mm_mult_hybrid 1 5000 5000 5000 > mm_mult_hybrid_8.txt
#mpirun -np 8 ./bin/mm_mult_hybrid 1 5000 5000 5000 >> mm_mult_hybrid_8.txt
#mpirun -np 8 ./bin/mm_mult_hybrid 1 5000 5000 5000 >> mm_mult_hybrid_8.txt
#mpirun -np 8 ./bin/mm_mult_hybrid 1 5000 5000 5000 >> mm_mult_hybrid_8.txt
#mpirun -np 8 ./bin/mm_mult_hybrid 1 5000 5000 5000 >> mm_mult_hybrid_8.txt

#./bin/mm_mult_serial_gnu 5000 5000 5000 > mm_mult_serial.txt
#./bin/mm_mult_serial_gnu 5000 5000 5000 >> mm_mult_serial.txt
#./bin/mm_mult_serial_gnu 5000 5000 5000 >> mm_mult_serial.txt
#./bin/mm_mult_serial_gnu 5000 5000 5000 >> mm_mult_serial.txt
#./bin/mm_mult_serial_gnu 5000 5000 5000 >> mm_mult_serial.txt


