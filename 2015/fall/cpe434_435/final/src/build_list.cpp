/**
 * Christopher Bero
 * CPE 434_435
 * Final Project
 * Build list of random numbers
 */

using namespace std;
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <stdio.h>

#define DEBUG false			/* whether to output matrices or not */
#define MX_SZ 320
#define SEED 2397           /* random number seed */
#define MAX_VALUE  100.0    /* maximum size of array elements A, and B */

/*
   MAIN ROUTINE: Create random number header
*/
int main( int argc, char *argv[])
{
	// Variables
	FILE *fp; // file pointer
	unsigned int index;
	unsigned long int data;

	fp = fopen("data.h","w");
	if (!fp)
	{
		printf("\nUnable to open file, error.");
		return 1;
	}

	srand48(SEED);

	fprintf(fp, "long unsigned int rdata[4000000] = {");
	for (index = 0; index < 4000000; index++)
	{
		data = (unsigned long int)lrand48();
		fprintf(fp, "%ld,", data);
	}
	data = (unsigned long int)lrand48();
	fprintf(fp, "%ld", data);
	fprintf(fp, "};");

	return(0);
}



