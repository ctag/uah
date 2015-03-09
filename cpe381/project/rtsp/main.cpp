#include <iostream>
#include <fstream>
#include <iomanip>

#include "waver.h"
#include "riffheader.h"

using namespace std;

int main()
{
    cout << "Hello world!" << endl;

	ifstream file("/home/berocs/Downloads/sample.wav", ios::binary);
	file >> std::noskipws;

	unsigned char x;
	int xi;
	unsigned char fs[4];
	unsigned int pos = 0;
	unsigned int fileSize = 0;

	while (file >> x && pos < 45)
	{
		cout << endl << std::hex << (int)x;
		//cout << ":" << std::hex << (int)(x+1);
		if (pos >= 4 && pos <= 7)
		{
			fs[pos-4] = x;
			fileSize += ((int)x << ((pos-4)*8));
		}
		if (pos > 7)
		{
			cout << std::hex << (int)fs[0] << (int)fs[1] << (int)fs[2] << (int)fs[3];
			cout << endl << fileSize;
			break;
		}
		++pos;
	}


    return 0;
}
