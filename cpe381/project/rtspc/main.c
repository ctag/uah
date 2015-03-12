#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "waver.h"

void print_properties (struct riffHeader _header)
{
printf("\n===============================================================\n");
//printf("%-20s %10s\n", "RIFF Header:", _header.riff);
//printf("%-20s %10s\n", "WAVE Header:", _header.wave);
//printf("%-20s %10s\n", "FORMAT Header:", _header.fmt);
printf("%-20s %10d\n", "File Size:", _header.size_file);
printf("%-20s %10d\n", "Channels:", _header.channels);
printf("%-20s %10d\n", "Sample Rate:", _header.sample_rate);
printf("%-20s %10d\n", "Bytes Per Second:", _header.bytes_second);
printf("%-20s %10d\n", "Sample Size:", _header.sample_size);
printf("%-20s %10d\n", "Bits Per Sample:", _header.bits_sample);
printf("%-20s %10d\n", "Data Size:", _header.size_data);
printf("\n===============================================================\n\n");
}

int main( int argc, char * argv[] )
{
	if (argc != 3)
	{
		printf("Usage: %s input_audio.wav output_audio.wav\n\n", argv[0]); // argv[0] usually holds program name.
		return(0);
	}

	FILE * input_file;
	//FILE * output_file;

	printf("opening file: %s", argv[1]);
	input_file = fopen(argv[1], "rb");

	if (input_file == 0) // fopen returns null pointer on error
	{
		printf("Could not open input file.\n");
		return(1);
	}
	struct riffHeader input_header;

	fread(&input_header, sizeof(struct riffHeader), 1, input_file);

	printf("Input file opened.");

	printf("Data: %d", input_header.size_file);

	print_properties(input_header);

	int _i;
	for (_i = 0; _i < 16; ++_i)
	{
		uint16_t sample;
		fread(&sample, sizeof(sample), 1, input_file);
		printf("Sample: %d\n", sample);
	}

    return 0;
}



