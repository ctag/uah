all: mm_mult_serial_gnu	mm_mult_serial_intel mm_mult_mpi_gnu mm_mult_mpi_intel

mm_mult_serial_gnu:
	g++ src/mm_mult_serial.cpp -o bin/mm_mult_serial_gnu -O3 -lm

mm_mult_serial_intel:
	icc src/mm_mult_serial.cpp -o bin/mm_mult_serial_intel -O3 -lm
	
mm_mult_mpi_gnu:
	export OMPI_CXX=g++
	mpic++ src/mm_mult_MPI.cpp -o bin/mm_mult_MPI_gnu -lm -O3

mm_mult_mpi_intel:
	export OMPI_CXX=icc
	mpic++ src/mm_mult_MPI.cpp -o bin/mm_mult_MPI_intel -lm  -O3

clean:
	rm bin/*
