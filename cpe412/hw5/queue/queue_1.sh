#!/bin/bash
# 2 processes, 4 threads each
mpirun -np 1 ../bin/mm_mult_hybrid 8 3000 3000 3000 > ../output/mm_mult_hybrid_1.txt
mpirun -np 1 ../bin/mm_mult_hybrid 8 3000 3000 3000 >> ../output/mm_mult_hybrid_1.txt
