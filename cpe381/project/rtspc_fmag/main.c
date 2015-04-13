/*
 * Includes
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h> /* M_PI */
// #include <tgmath.h> /* For type indifferent sine function */
#include <time.h>
#include <limits.h>
#include <stdbool.h>

/*
 * Project Header
 */
#include "waver.h"
#include "kiss_fftr.h"

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
	printf("RTSPC_FMAG\n");
	printf("By: Christopher Bero [csb0019@uah.edu]\n");
	printf("For CPE 381 - Project Errata - April 2015\n");
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

/*
 * Print an overview of available flags
 */
void print_usage (char program[])
{
	// This block of text is modeled after the command `vim -h`
	print_bar();
	printf("Usage: \n%s [-h] [-s sum.txt] -i in.wav -o out.dat\n", program);
	printf("Arguments: \n");
	printf("%-10s %-45s\n", "-i", "Input WAVE file. Required.");
	printf("%-10s %-45s\n", "-o", "Output DAT file. For Gnuplot.");
	printf("%-10s %-45s\n", "-s", "Summary file name.");
	printf("%-10s %-45s\n", "-h", "Print this help and exit.");
	print_bar();
}

/*
 * Main method
 */
int main( int argc, char * argv[] )
{
	/**
	 * Setup Clock
	 */
	clock_t runTime; // Create clock
	runTime = clock(); // Assign current CLOCK_TICKS

	/**
	 * Print Header
	 */
	print_header();

	/**
	 * Declare variables
	 */
	struct riffHeader input_header; // packed structure for RIFF file header
	short unsigned int inputFileIndex = 0, outputFileIndex = 0, summaryFileIndex = 0; // location of file names in argv[]
	unsigned long int _index; // Generic for() loop index

	double samplePeriod = 0; // Period of sample
	unsigned long int num_bytes = 0; // number of bytes in file
	unsigned long int num_samples = 0; // number of samples in file
	unsigned long int num_captures = 0; // number of captures (2 sample instances) in file

	/**
	 * Check that the correct number of arguments exist.
	 * If they exist, process them into appropriate variables.
	 */
	if (argc < 3 || argc > 12)
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
	open_file(&output_file, argv[outputFileIndex], false, true);
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
	// Get header from input file
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

	// Parse header
	samplePeriod = (1.0 / input_header.sample_rate);
	num_bytes = (input_header.size_data-8);
	num_samples = num_bytes/2;
	num_captures = ((num_samples/4)*2);
	unsigned int num_bins = (num_captures/2)+1;

	// List information from header
	print_properties(input_header);

	// Variables for the processing loop
	unsigned short int sample_size = sizeof(int16_t);
	kiss_fftr_cfg cfg = kiss_fftr_alloc(num_captures, 0, NULL, NULL);
	kiss_fft_scalar timedata[num_captures];
	kiss_fft_cpx *freqdata;
	freqdata = (kiss_fft_cpx *)calloc(num_bins, sizeof(kiss_fft_cpx));

	/**
	 * Process input file two samples at a time
	 */
	printf("Processing samples... ");
	for (_index = 0; _index < num_captures; ++_index)
	{
		//printf("index: %d", _index);
		// Local variables
		int16_t sample_left, sample_right;

		// Pull next sample
		fread(&sample_left, sample_size, 1, input_file);
		fread(&sample_right, sample_size, 1, input_file);

		// Processing here
		timedata[_index] = (kiss_fft_scalar)sample_left;
		//printf("\ntimedata[%d]: %f \t %d", _index, timedata[_index], sample_left);
	}
	//const kiss_fft_scalar * timeptr = &timedata;
	kiss_fftr(cfg, &timedata, freqdata);
	free(cfg);
	printf("Done!\n");

	printf("\n\nProcessing freqdata... ");

	unsigned long int fft_max = 0;
	int index_max = 0;
	// calculate max
	for (_index = 0; _index < num_bins; ++_index)
	{
		unsigned long int freqpt = (unsigned long int)fabs(freqdata[_index].r);
		if (freqpt > fft_max)
		{
			fft_max = freqpt;
			index_max = _index;
		}

	}
	printf("\nMax: %lu", fft_max);
	//long unsigned int _threshold = ((float)fft_max*0.0005);
	//printf("\nThreshold: %lu.\n", _threshold);
	unsigned long int fft_previous = 0;
	for (_index = 0; _index < num_bins; ++_index)
	{
		unsigned long int freqpt = (unsigned long int)fabs(freqdata[_index].r);
		//if (abs(freqpt - fft_previous) > _threshold)
		//{
			fprintf(output_file, "%lu\t%lu\t%f\n", _index, freqpt, freqdata[_index].r);
			fft_previous = freqdata[_index].r;
		//}
	}

	/**
	 * End Clock
	 */
	runTime = clock() - runTime;

	/**
	 * Create summary file
	 */
	if (summary_file)
	{
		printf("Writing summary file.\n");
		double file_time = (samplePeriod * _index);
		fprintf(summary_file, "Summary File - CPE 381 - Christopher Bero\n");
		fprintf(summary_file, "=========================================\n");
		fprintf(summary_file, "%-25s %13dHz\n", "Sampling Frequency:", input_header.sample_rate);
		fprintf(summary_file, "%-25s %14fs\n", "Audio Time:", file_time);
		fprintf(summary_file, "%-25s %14fs\n", "Program Execution Time:", ((float)runTime / CLOCKS_PER_SEC));
		fclose(summary_file);
	}

	// Tidy up file streams
	fclose(input_file);
	fclose(output_file);
    return(0);
}




















