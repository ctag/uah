all: mm_mult_hybrid mm_mult_serial_gnu
	
# laplace2d_acc.cpp  laplace2d_omp.cpp  matrix_mult_serial2.cpp  timer.h

laplace2d_acc.cpp:
	# pgcpp fails when the source file isn't in the same folder
	cd src;	pgc++ -fast laplace2d_acc.cpp -o ../bin/laplace2d_acc -acc -ta=nvidia -Minfo=accel
#	pgc++ src/laplace2d_acc.cpp -o bin/laplace2d_acc -acc -ta=nvidia,time -Minfo=accel --restrict

laplace2d_omp:
	pgc++ src/laplace2d_omp.cpp -fast -mp -o bin/laplace2d_omp

laplace2d_omp_gnu:
	g++  -o bin/laplace2d_omp_gnu src/laplace2d_omp.cpp -O3 -fopenmp -Wall
	
matrix_mult_serial2:
	g++ -o bin/matrix_mult_serial2 -O3 src/matrix_mult_serial2.cpp

#	export OMPI_CXX=g++
#	mpic++ src/mm_mult_hybrid.cpp -o bin/mm_mult_hybrid -O3 -fopenmp -Wall

clean:
	rm bin/*
	rm src/*.o
