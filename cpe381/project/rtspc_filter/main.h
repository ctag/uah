#include <stdint.h>

#ifndef WAVER_H_INCLUDED
#define WAVER_H_INCLUDED

/**
 * Sampling struct
 */
typedef struct {
    int16_t l; // Left (or mono) channel
    int16_t r; // Right channel
} Sample;

/**
 * Default Sine Wave:
 * Generated with MATLAB R2012a
 * Amplitude: 0.25*(32767)
 * Frequency: 2400Hz
 * One Period: (1/2400)s
 * Resolution: (1/44100)s
 * Array Size: (1/2400)/(1/44100) = 18.375 ~ 19
 */
const static int16_t default_sine[] = {0,2747,5176,7005,8023,8113,7263,5572,3236,525,-2247,-4758,-6719,-7901,-8169,-7491,-5945,-3711,-1048};

/**
 * http://www.topherlee.com/software/pcm-tut-wavformat.html
 *
 * Format:
 * [1-4]	- "RIFF" - Marks file as RIFF type.
 * [5-8]	- File Size (integer) minus 8 bytes.
 * [9-12]	- "WAVE" - File type header.
 * [13-16]	- "fmt " - Format chunk marker.
 * [17-20]	- Length of "format data" area. Typically 16 for PCM.
 * [21-22]	- Type of format. "1" is PCM, which we work with.
 * [23-24]	- Number of channels (integer).
 * [25-28]	- Sample Rate = # of samples per second or Hz.
 * [29-32]	- (Sample Rate * Bits Per Sample * Channels) / 8
 *			- Bytes per Second.
 * [33-34]	- (Bits Per Sample * Channels) / 8.
 *			- 1: 8 bit mono. 2: 8 bit stereo. 3: 16 bit mono. 4: 16 bit stereo.
 * [35-36]	- Bits Per Sample.
 * [37-40]	- "data" - Data chunk header. Included in "size of data" below.
 * [41-44]	- Size of data section in bytes.
 */

 struct riffHeader {
    char 		riff[4]; 	// "RIFF"
    uint32_t 	size_file;
    char 		wave[4]; 	// "WAVE"
    char 		fmt[4]; 	// "fmt "
    uint32_t 	size_fmt; 	// 16 for PCM
    uint16_t 	type_fmt; 	// 1 for PCM
    uint16_t 	channels; 	// 2 for stereo
    uint32_t 	sample_rate;//
    uint32_t 	bytes_second;// Bytes per Second
    uint16_t 	sample_size;// total sample size (bytes)
    uint16_t 	bits_sample;// Bits per Sample
    char 		data[4]; 	// "data"
    uint32_t 	size_data; 	// size of data from char data to end of section
 }__attribute__((__packed__)); // Use struct as a memory-map

#endif // WAVER_H_INCLUDED
