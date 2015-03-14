/*
 * Includes
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>
#include <stdbool.h>

/*
 * Project Header
 */
#include "waver.h"

/*
 * Print a formatting bar
 */
void print_bar ()
{
	printf("============================================================================\n");
}

/*
 * Print a generic header
 */
void print_header ()
{
	print_bar();
	printf("RTSPC : Real Time Signal Processing, C\n");
	printf("By: Christopher Bero [csb0019@uah.edu]\n");
	printf("For CPE 381 - Project Part 1 - March 2015\n");
	printf("-> This program overlays a sine wave on any \n");
	printf("-> 2ch, 16bit, uncompressed .wav file.\n");
	print_bar();
}

/*
 * List properties gathered from RIFF header
 */
void print_properties (struct riffHeader _header)
{
	print_bar();
	printf("%-20s %10dB\n", "File Size:", _header.size_file);
	printf("%-20s %10d\n", "Channels:", _header.channels);
	printf("%-20s %10dHz\n", "Sample Rate:", _header.sample_rate);
	printf("%-20s %10dBps\n", "Bytes Per Second:", _header.bytes_second);
	printf("%-20s %10dB\n", "Sample Size:", _header.sample_size);
	printf("%-20s %10db\n", "Bits Per Sample:", _header.bits_sample);
	printf("%-20s %10dB\n", "Data Size:", _header.size_data);
	print_bar();
}

/*
 * Open a WAV file
 */
void open_file (FILE ** _ptr, char _argv[], bool binary, bool write)
{
	printf("Opening file '%s' for %s.\n", _argv, ((write) ? "writing" : "reading"));
	char stream_params[2] = {'r', '\0'}; // Default to reading file
	if (write) // Open file in correct mode if writing
	{
		stream_params[0] = 'w';
	}
	if (binary) // Open file as binary, otherwise treated as text
	{
		stream_params[1] = 'b';
	}
	*_ptr = fopen(_argv, stream_params);
}

void print_usage (char program[])
{
	// This block of text is modeled after the command `vim -h`
		print_bar();
		printf("Usage: \n%s -i input.wav -o output.wav [-s summary.txt] [-a 0.25] [-f 2400] [-h]\n", program);
		printf("Arguments: \n");
		printf("%-10s %-45s\n", "-i", "Input WAVE file. Required.");
		printf("%-10s %-45s\n", "-o", "Output WAVE file. Required.");
		printf("%-10s %-45s\n", "-s", "Summary file name.");
		printf("%-10s %-45s\n", "-a", "Set sine amplitude. Double. Default 0.25.");
		printf("%-10s %-45s\n", "-f", "Set sine frequency. Integer. Default 2.4KHz.");
		printf("%-10s %-45s\n", "-h", "Print this help and exit.");
		print_bar();
}

/*
 * Main method
 */
int main( int argc, char * argv[] )
{
	print_header();

	/**
	 * Declare variables
	 */
	struct riffHeader input_header; // packed structure for RIFF file header
	short unsigned int inputFileIndex = 0, outputFileIndex = 0, summaryFileIndex = 0; // location of file names in argv[]
	unsigned int _index; // Generic for() loop index

	double sineAmplitude = 0.25; // Amplitude of sine wave relative to sample container
	int sineFrequency = 2400; // Frequency of sine wave in Hz
	double samplePeriod = 0; // Period of sample
	int num_bytes = 0; // number of bytes in file
	int num_samples = 0; // number of samples in file
	int num_captures = 0; // number of captures (2 sample instances) in file

	short int maxSampleAmplitude = 0; // Value of max sample
	unsigned int maxSampleIndex = 0; // Position of max sample
	short unsigned int maxSampleChannel = 0; // Channel of max sample

	/**
	 * Check that the correct number of arguments exist.
	 * If they exist, process them into appropriate variables.
	 */
	if (argc < 5 || argc > 11)
	{
		// argv[0] usually holds the executable name.
		print_usage(argv[0]);
		return(0); // End process and give the user another shot to format the command.
	} else { // Process the arguments
		for (_index = 1; _index < argc; ++_index) // Loop through all arguments
		{
			if (argv[_index][0] == '-') // Argument is a flag, format should be '-* '
			{
				if (argv[_index][1] == 'h')
				{
					print_usage(argv[0]);
					return(1);
				}
				// Check that there is a parameter to store
				if (_index+1 >= argc) // There is no param to store
				{
					printf("\nInvalid flag. Halting.\n\n");
					print_usage(argv[0]);
				}
				// Begin testing passed flag
				if (argv[_index][1] == 'i') // Input filename should be next param
				{
					inputFileIndex = ++_index; // Increment index to skip checking the filename, and also store as the file index.
				} else if (argv[_index][1] == 'o') // Output filename should be next param
				{
					outputFileIndex = ++_index;
				} else if (argv[_index][1] == 's') // Summary filename should be next param
				{
					summaryFileIndex = ++_index;
				} else if (argv[_index][1] == 'a') // Amplitude is next param
				{
					sineAmplitude = atof(argv[++_index]); // Convert the value to fp
				} else if (argv[_index][1] == 'f') // Frequency is next param
				{
					sineFrequency = atoi(argv[++_index]); // Convert value to int
				}
			}
		}
	}

	/**
	 * Check that required params are read in correctly
	 */
	if (inputFileIndex == 0 || outputFileIndex == 0)
	{
		printf("Improper flag usage. Halting.");
		print_usage(argv[0]);
		return(1);
	}

	/**
	 * Setup File Streams
	 */
	FILE * input_file = 0;
	FILE * output_file = 0;
	FILE * summary_file = 0;

	open_file(&input_file, argv[inputFileIndex], true, false);
	open_file(&output_file, argv[outputFileIndex], true, true);
	if (summaryFileIndex != 0)
	{
		open_file(&summary_file, argv[summaryFileIndex], false, true);
	}

	if (!input_file)
	{
		printf("Could not open input file stream. Program halting.\n");
		return(1);
	}
	printf("Input file opened.\n");

	if (!output_file)
	{
		printf("Could not open output file stream. Program halting.\n");
		return(1);
	}
	printf("Output file opened.\n");

	if (!summary_file && summaryFileIndex)
	{
		printf("Could not open summary file stream. Program halting.\n");
		return(1);
	} else if (summary_file)
	{
		printf("Summary file opened.\n");
	}

	/**
	 * Read input file header
	 * Parse
	 * Print Header Details
	 * Write output file header
	 */
	fread(&input_header, sizeof(struct riffHeader), 1, input_file);

	// Perform some basic error checking.
	if (input_header.channels != 2)
	{
		printf("Wrong number of channels. Halting.");
		return(1);
	}
	if (input_header.bits_sample != 16)
	{
		printf("Wrong number of bits per sample. Halting.");
		return(1);
	}
	if (input_header.type_fmt != 1)
	{
		printf("Wrong format, looking for a PCM formatted file. Halting.");
		return(1);
	}

	samplePeriod = (1.0 / input_header.sample_rate);
	num_bytes = (input_header.size_data-8);
	num_samples = num_bytes/2;
	num_captures = num_samples/2;

	print_properties(input_header);

	fwrite(&input_header, sizeof(struct riffHeader), 1, output_file);

	/**
	 * Process input file two samples at a time
	 */
	unsigned short int sample_size = sizeof(int16_t);
	for (_index = 0; _index < num_captures; ++_index)
	{
		int16_t sample_left, sample_right;
		double _sinVal;

		fread(&sample_left, sample_size, 1, input_file);
		fread(&sample_right, sample_size, 1, input_file);

		if (abs(sample_left) > maxSampleAmplitude)
		{
			maxSampleAmplitude = abs(sample_left);
			maxSampleIndex = _index;
			maxSampleChannel = 1;
		}
		if (abs(sample_right) > maxSampleAmplitude)
		{
			maxSampleAmplitude = abs(sample_right);
			maxSampleIndex = _index;
			maxSampleChannel = 2;
		}

		_sinVal = sin(2*M_PI*(samplePeriod*_index)*sineFrequency)*(sineAmplitude*SHRT_MAX);

		sample_left = sample_left + (_sinVal);
		sample_right = sample_right + (_sinVal);

		fwrite(&sample_left, sample_size, 1, output_file);
		fwrite(&sample_right, sample_size, 1, output_file);

	}

	/**
	 * Create summary file
	 */
	if (summary_file)
	{
		//
	}

    return(0);
}



