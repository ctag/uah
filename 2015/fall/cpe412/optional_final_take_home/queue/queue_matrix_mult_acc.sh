#!/bin/bash
# Laplace job Action 2.1

module load pgi

../bin/matrix_mult_acc 8000 > ../output/matrix_mult_acc.txt
../bin/matrix_mult_acc 8000 >> ../output/matrix_mult_acc.txt
../bin/matrix_mult_acc 8000 >> ../output/matrix_mult_acc.txt
../bin/matrix_mult_acc 8000 >> ../output/matrix_mult_acc.txt
../bin/matrix_mult_acc 8000 >> ../output/matrix_mult_acc.txt


