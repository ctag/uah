#../bin/bash

module load pgi

OMP_NUM_THREADS=2; ../bin/laplace2d_omp >> ../output/test_omp.txt
OMP_NUM_THREADS=4; ../bin/laplace2d_omp >> ../output/test_omp.txt
OMP_NUM_THREADS=8; ../bin/laplace2d_omp >> ../output/test_omp.txt

exit

export OMP_NUM_THREADS=1
../bin/laplace2d_omp > ../output/laplace2d_omp_1.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_1.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_1.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_1.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_1.txt

export OMP_NUM_THREADS=2
../bin/laplace2d_omp > ../output/laplace2d_omp_2.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_2.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_2.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_2.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_2.txt

export OMP_NUM_THREADS=4
../bin/laplace2d_omp > ../output/laplace2d_omp_4.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_4.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_4.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_4.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_4.txt

export OMP_NUM_THREADS=8
../bin/laplace2d_omp > ../output/laplace2d_omp_8.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_8.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_8.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_8.txt
../bin/laplace2d_omp >> ../output/laplace2d_omp_8.txt


