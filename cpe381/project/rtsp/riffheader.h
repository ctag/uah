#ifndef RIFFHEADER_H
#define RIFFHEADER_H

/**
 * RiffHeader
 * A class to keep track of .wav file data
 */

/**
 * http://www.topherlee.com/software/pcm-tut-wavformat.html
 *
 * Format:
 * [1-4]	- "RIFF" - Marks file as RIFF type.
 * [5-8]	- File Size (integer) minus 8 bytes.
 * [9-12]	- "WAVE" - File type header.
 * [13-16]	- "fmt " - Format chunk marker.
 * [17-20]	- Length of "format data" area.
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

class riffHeader
{
	public:
		/** Default constructor */
		riffHeader();
		riffHeader(char header[45]);
		/** Default destructor */
		virtual ~riffHeader();

	protected:
		bool riffHead;
		bool waveHead;
		bool fmtHead;
		bool dataHead;
		unsigned int fileSize;
		unsigned int fmtSize;
		unsigned int fmtType;
		unsigned int channels;
		unsigned int sampleRate;
		unsigned int bitsPerSample;
		unsigned int dataSize;

	private:

};

#endif // RIFFHEADER_H
