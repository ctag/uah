all: mm_mult_serial_gnu	mm_mult_pthread_gnu

mm_mult_serial_gnu:
	g++ src/mm_mult_serial.cpp -o bin/mm_mult_serial_gnu -O3 -lm -Wall

mm_mult_pthread_gnu:
	g++ src/mm_mult_pthread_gnu.cpp -o bin/mm_mult_pthread_gnu -O3 -lm -Wall -pthread

clean:
	rm bin/*
	rm src/*.o
