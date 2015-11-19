all: tsp_serial tsp_omp
	
tsp_serial:
	g++ src/tsp_serial.cpp -o bin/tsp_serial -O3 -lm -Wall
	
tsp_omp:
	#export OMPI_CXX=g++
	g++ src/tsp_omp.cpp -o bin/tsp_omp -lm -O3 -Wall -fopenmp

clean:
	rm bin/*
	rm src/*.o
