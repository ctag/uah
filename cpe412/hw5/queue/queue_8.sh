#!/bin/bash
# 8 processes, 1 thread each
mpirun -np 8 ../bin/mm_mult_hybrid 1 3000 3000 3000 > ../output/mm_mult_hybrid_8.txt
mpirun -np 8 ../bin/mm_mult_hybrid 1 3000 3000 3000 >> ../output/mm_mult_hybrid_8.txt
