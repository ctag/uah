#!/bin/bash
# 2 processes, 4 threads each
mpirun -np 2 ../bin/mm_mult_hybrid 4 3000 3000 3000 > ../output/mm_mult_hybrid_2.txt
mpirun -np 2 ../bin/mm_mult_hybrid 4 3000 3000 3000 >> ../output/mm_mult_hybrid_2.txt
