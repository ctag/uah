all: mm_mult_hybrid mm_mult_serial_gnu
	
# laplace2d_acc.cpp  laplace2d_omp.cpp  matrix_mult_serial2.cpp  timer.h

laplace2d_acc.cpp:
	pgc++ src/laplace_acc.cpp -o bin/laplace_acc -acc -ta=nvidia,time -Minfo=accel --restrict
#	g++ src/mm_mult_serial.cpp -o bin/mm_mult_serial_gnu -O3

laplace2d_omp:
	g++  -o bin/laplace2d_omp src/laplace2d_omp.cpp -O3 -fopenmp -Wall
	
matrix_mult_serial2:
	g++ -o bin/matrix_mult_serial2 -O3 src/matrix_mult_serial2.cpp

#	export OMPI_CXX=g++
#	mpic++ src/mm_mult_hybrid.cpp -o bin/mm_mult_hybrid -O3 -fopenmp -Wall

clean:
	rm bin/*
	rm src/*.o
