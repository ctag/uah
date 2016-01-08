#!/bin/bash
# 4 processes, 2 threads each
mpirun -np 4 ../bin/mm_mult_hybrid 2 3000 3000 3000 > ../output/mm_mult_hybrid_4.txt
mpirun -np 4 ../bin/mm_mult_hybrid 2 3000 3000 3000 >> ../output/mm_mult_hybrid_4.txt
