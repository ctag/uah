all: mm_mult_hybrid
	
mm_mult_serial_gnu:
	g++ src/mm_mult_serial.cpp -o bin/mm_mult_serial_gnu -O3 -lm -Wall
	
mm_mult_hybrid:
	export OMPI_CXX=g++
	mpic++ src/mm_mult_hybrid.cpp -o bin/mm_mult_hybrid -lm -O3 -Wall -fopenmp

clean:
	rm bin/*
	rm src/*.o
