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
#include "data.h"

/*
   MAIN ROUTINE: Create random number header
*/
int main( int argc, char *argv[])
{
	unsigned int index;

	for (index = 0; index < 10; index++)
	{
		printf("data: %ld\n", rdata[index]);
	}

	return(0);
}



