#!/bin/bash


#module load openmpi
#module load openmpi/1.10.1-gnu

mpirun -np 4 ./bin/mm_mult_hybrid 2 3000 3000 3000 > mm_mult_hybrid_4.txt
mpirun -np 4 ./bin/mm_mult_hybrid 2 3000 3000 3000 >> mm_mult_hybrid_4.txt
mpirun -np 4 ./bin/mm_mult_hybrid 2 3000 3000 3000 >> mm_mult_hybrid_4.txt
mpirun -np 4 ./bin/mm_mult_hybrid 2 3000 3000 3000 >> mm_mult_hybrid_4.txt
mpirun -np 4 ./bin/mm_mult_hybrid 2 3000 3000 3000 >> mm_mult_hybrid_4.txt

