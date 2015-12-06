#!/bin/bash
# 2 processes, 4 threads each
mpirun -np 1 ../bin/mm_mult_hybrid 1 3000 3000 3000 > ../output/mm_mult_hybrid_serial.txt
mpirun -np 1 ../bin/mm_mult_hybrid 1 3000 3000 3000 >> ../output/mm_mult_hybrid_serial.txt
