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
#include "main.h"

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
	printf("RTSPC_FILTER\n");
	printf("By: Christopher Bero [csb0019@uah.edu]\n");
	printf("For CPE 381 - Project Part 2 - April 2015\n");
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
	printf("Usage: \n%s [-h] [-r] [-s sum.txt] -i in.wav -o out.wav\n", program);
	printf("Arguments: \n");
	printf("%-10s %-45s\n", "-i", "Input WAVE file. Required.");
	printf("%-10s %-45s\n", "-o", "Output WAVE file. Required.");
	printf("%-10s %-45s\n", "-s", "Summary file name.");
	printf("%-10s %-45s\n", "-r", "Use IIR recursive filter. Default is FIR.");
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

	/**
	 * Print Header
	 */
	print_header();

	/**
	 * Declare variables
	 */
	struct riffHeader input_header; // packed structure for RIFF file header
	short unsigned int inputFileIndex = 0, outputFileIndex = 0, summaryFileIndex = 0; // location of file names in argv[]
	unsigned int _index; // Generic for() loop index
	float samplePeriod = 0; // Period of sample
	float sampleRate = 0; // Sampling rate, used to find samplePeriod.
	int num_bytes = 0; // number of bytes in file
	int num_samples = 0; // number of samples in file
	int num_captures = 0; // number of captures (2 sample instances) in file
	bool stereo = false; // Set one or two channel input
	bool use_iir = false; // command line argument
	int filter_size = 0; // Size of filter and input buffer
	int buffer_out_size = 1; // For FIR, buffer out is 1
	const real64_T * filter = NULL; // pointer to the filter/numerator in use, b
	const real64_T * filter_den = NULL; // pointer to the denominator in use, a

	/**
	 * Check that the correct number of arguments exist.
	 * If they exist, process them into appropriate variables.
	 * argv[0] usually holds the executable name.
	 */
	if (argc < 3 || argc > 9)
	{
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
				} else if (argv[_index][1] == 'r') // Use IIR
				{
					use_iir = true;
				} else { // Default case, a bad flag has been given.
					print_usage(argv[0]);
					return(1);
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
	 */
	// Get header from input file
	fread(&input_header, sizeof(struct riffHeader), 1, input_file);
	// Perform some basic error checking.
	if (input_header.channels > 2 || input_header.channels < 1)
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

	/**
	 * Parse header
	 */
	sampleRate = input_header.sample_rate;
	samplePeriod = (1.0 / sampleRate);
	num_bytes = (input_header.size_data-8);
	num_samples = num_bytes/2;
	num_captures = num_samples/2;

	if (input_header.channels == 2)
	{
		stereo = true;
	} else if (input_header.channels > 2 || input_header.channels < 1) {
		printf("Unsupported number of channels: %d. Program halting.", input_header.channels);
		return(1);
	}

	// Check sample rate
	if (sampleRate == 44100)
	{
		printf("Using ");
		if (use_iir) {
			printf("IIR");
			filter_size = NL_44100;
			buffer_out_size = DL_44100;
			filter = NUM_44100;
			filter_den = DEN_44100;
		} else {
			printf("FIR");
			filter_size = BL_44100;
			filter = B_44100;
		}
		printf(" filter for 44100KHz sampling frequency.\n");
	} else if (sampleRate == 22050) {
		printf("\nUsing ");
		if (use_iir) {
			printf("IIR");
			filter_size = NL_22050;
			buffer_out_size = DL_22050;
			filter = NUM_22050;
			filter_den = DEN_22050;
		} else {
			printf("FIR");
			filter_size = BL_22050;
			filter = B_22050;
		}
		printf(" filter for 22050KHz sampling frequency. ");
	} else {
		printf("\nUnsupported sampling rate: %f. Program halting.", sampleRate);
		return(1);
	}

	// List information from header
	print_properties(input_header);

	// Write unaltered header to output file
	fwrite(&input_header, sizeof(struct riffHeader), 1, output_file);

	/**
	 * Setup variables for processing loop
	 */
	unsigned short int sample_size = sizeof(int16_t);
	Sample * buffer_in;
	// Perhaps float datatype will give me better precision for IIR? Its an experiment!
	SampleReal * buffer_out;
	long unsigned int processingTime = 0;

	buffer_in = (Sample*)calloc(filter_size,sizeof(Sample));
	buffer_out = (SampleReal*)calloc((buffer_out_size),sizeof(SampleReal));

	// Initialize buffers
	for (_index = 0; _index < (filter_size); ++_index)
	{
		buffer_in[_index].l = 0;
		buffer_in[_index].r = 0;
	}
	for (_index = 0; _index < (buffer_out_size); ++_index)
	{
		buffer_out[_index].l = 0;
		buffer_out[_index].r = 0;
	}

	/**
	 * Start timer
	 */
	printf("\nfilter_size: %d, buffer_out_size: %d.", filter_size, buffer_out_size);
	printf("\nProcessing samples");
	fflush(stdout);
	runTime = clock(); // Assign current CLOCK_TICKS

	/**
	 * Process input file two samples (one capture) at a time.
	 */
	for (_index = 0; _index < num_captures; ++_index)
	{
		// Local variables
		long int _i = 0;
		long unsigned int currentTime = ((clock() - runTime) / CLOCKS_PER_SEC);
		Sample output;
		SampleReal accumulator;
		accumulator.l = 0;
		accumulator.r = 0;

		// Shift buffer_in to make room for new sample and accumulate output
		for (_i = (filter_size-1); _i > 0; --_i)
		{
			buffer_in[_i].l = buffer_in[_i-1].l;
			buffer_in[_i].r = buffer_in[_i-1].r;
			accumulator.l += (buffer_in[_i].l*filter[_i]);
			accumulator.r += (buffer_in[_i].r*filter[_i]);
		}

		// Pull next sample into buffer_in
		fread(&buffer_in[0].l, sample_size, 1, input_file);
		if (stereo)
		{
			// This loses a considerable amount of performance for mono files.
			fread(&buffer_in[0].r, sample_size, 1, input_file);
		}

		// Process t=0 sample
		accumulator.l += (buffer_in[0].l*filter[0]);
		accumulator.r += (buffer_in[0].r*filter[0]);

		// Shift buffer_out,
		// If FIR, then this is skipped due to the buffer size of 1
		for (_i = (buffer_out_size-1); _i > 0; --_i)
		{
			buffer_out[_i].l = buffer_out[_i-1].l;
			buffer_out[_i].r = buffer_out[_i-1].r;
			accumulator.l -= (buffer_out[_i].l*filter_den[_i]);
			accumulator.r -= (buffer_out[_i].r*filter_den[_i]);
		}

		// Compute next value for buffer_out
		buffer_out[0].l = accumulator.l;
		buffer_out[0].r = accumulator.r;
		output.l = (int16_t)accumulator.l;
		output.r = (int16_t)accumulator.r;

		// Write modified capture to output stream
		fwrite(&output.l, sample_size, 1, output_file);
		if (stereo)
		{
			fwrite(&output.r, sample_size, 1, output_file);
		}

		// Print rolling ellipses
		if ( currentTime > processingTime)
		{
			processingTime = currentTime+2;
			printf(".");
			fflush(stdout);
		}

	}

	/**
	 * End Clock
	 */
	runTime = clock() - runTime;
	printf(" Done!\n");

	/**
	 * Clean up from processing
	 */
	free(buffer_in);
	free(buffer_out);

	/**
	 * Create summary file
	 */
	if (summary_file)
	{
		float executionTime = ((float)runTime / CLOCKS_PER_SEC);
		printf("Writing summary file.\n");
		double file_time = (samplePeriod * _index);
		fprintf(summary_file, "Summary File - CPE 381 - Christopher Bero\n");
		fprintf(summary_file, "=========================================\n");
		fprintf(summary_file, "%-25s %13dHz\n", "Sampling Frequency:", input_header.sample_rate);
		fprintf(summary_file, "%-25s %14fs\n", "Audio Time:", file_time);
		fprintf(summary_file, "%-25s %14fs\n", "Program Execution Time:", executionTime);
		fprintf(summary_file, "%-25s %15s\n", "Ran in:", ((file_time >= (int)executionTime)?"Real Time!":"Not Real Time."));
		fclose(summary_file);
	}

	/**
	 * Close file streams
	 */
	fclose(input_file);
	fclose(output_file);

    return(0);
}














