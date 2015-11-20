#!/bin/bash


#module load openmpi
#module load openmpi/1.10.1-gnu

mpirun -np 8 ./bin/mm_mult_hybrid 1 3000 3000 3000 > mm_mult_hybrid_8.txt
mpirun -np 8 ./bin/mm_mult_hybrid 1 3000 3000 3000 >> mm_mult_hybrid_8.txt
mpirun -np 8 ./bin/mm_mult_hybrid 1 3000 3000 3000 >> mm_mult_hybrid_8.txt
mpirun -np 8 ./bin/mm_mult_hybrid 1 3000 3000 3000 >> mm_mult_hybrid_8.txt
mpirun -np 8 ./bin/mm_mult_hybrid 1 3000 3000 3000 >> mm_mult_hybrid_8.txt

