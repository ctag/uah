all: mm_mult_hybrid mm_mult_serial_gnu
	
mm_mult_serial_gnu:
	g++ src/mm_mult_serial.cpp -o bin/mm_mult_serial_gnu -O3

mm_mult_omp:
	g++ src/mm_mult_omp.cpp -o bin/mm_mult_omp -O3 -fopenmp -Wall
	
mm_mult_hybrid:
	export OMPI_CXX=g++
	mpic++ src/mm_mult_hybrid.cpp -o bin/mm_mult_hybrid -O3 -fopenmp -Wall

clean:
	rm bin/*
	rm src/*.o
