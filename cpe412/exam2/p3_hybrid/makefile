all: mm_mult_hybrid mm_mult_serial_gnu
	
mm_mult_serial_gnu:
	g++ src/mm_mult_serial.cpp -o bin/mm_mult_serial_gnu -O3
	
mm_mult_hybrid:
	export OMPI_CXX=g++
	mpic++ -openmp src/mm_mult_hybrid.cpp -o bin/mm_mult_hybrid -O3

clean:
	rm bin/*
	rm src/*.o
