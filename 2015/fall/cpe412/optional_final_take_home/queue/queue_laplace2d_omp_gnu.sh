#../bin/bash

export OMP_NUM_THREADS=1
../bin/laplace2d_omp_gnu > ../output/laplace2d_omp_gnu_1.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_1.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_1.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_1.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_1.txt

export OMP_NUM_THREADS=2
../bin/laplace2d_omp_gnu > ../output/laplace2d_omp_gnu_2.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_2.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_2.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_2.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_2.txt

export OMP_NUM_THREADS=4
../bin/laplace2d_omp_gnu > ../output/laplace2d_omp_gnu_4.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_4.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_4.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_4.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_4.txt

export OMP_NUM_THREADS=8
../bin/laplace2d_omp_gnu > ../output/laplace2d_omp_gnu_8.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_8.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_8.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_8.txt
#../bin/laplace2d_omp_gnu >> ../output/laplace2d_omp_gnu_8.txt


