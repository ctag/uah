#!/bin/bash


#module load openmpi
#module load openmpi/1.10.1-gnu

mpirun -np 2 ./bin/mm_mult_hybrid 4 3000 3000 3000 > mm_mult_hybrid_2.txt
mpirun -np 2 ./bin/mm_mult_hybrid 4 3000 3000 3000 >> mm_mult_hybrid_2.txt
mpirun -np 2 ./bin/mm_mult_hybrid 4 3000 3000 3000 >> mm_mult_hybrid_2.txt
mpirun -np 2 ./bin/mm_mult_hybrid 4 3000 3000 3000 >> mm_mult_hybrid_2.txt
mpirun -np 2 ./bin/mm_mult_hybrid 4 3000 3000 3000 >> mm_mult_hybrid_2.txt

