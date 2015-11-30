all: mergesort_mpi mergesort_serial mergesort_mpi_recursive mergesort_serial_recursive

	
mergesort_mpi:
		export OMPI_CXX=g++
		mpic++ src/mergesort_mpi.cpp -o bin/mergesort_mpi -lm -O3 -Wall

mergesort_mpi_recursive:
		export OMPI_CXX=g++
		mpic++ src/mergesort_mpi_recursive.cpp -o bin/mergesort_mpi_recursive -lm -O3 -Wall

mergesort_serial:
	g++ src/mergesort_serial.cpp -o bin/mergesort_serial -Wall -g

mergesort_serial_recursive:
	g++ src/mergesort_serial_recursive.cpp -o bin/mergesort_serial_recursive -Wall -g

build_list:
	g++ src/build_list.cpp -o bin/build_list -O3 -Wall

test_list:
	g++ src/test_list.cpp -o bin/test_list -O3 -Wall
	
clean:
	rm bin/*
	rm src/*.o
