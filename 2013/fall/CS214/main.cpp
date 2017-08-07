// 
// CS 214 Sets Project 01
// Chris Bero 
//

//
// Includes
//
#include <iostream>		/* Standard input/output */
#include <fstream>		/* Standard file stream */
#include <string>		/* Let's have string support */
#include <stdlib.h>		/* G++ has stricter compile requirements, stdlib.h is needed for atoi. */
#include <sstream>		/* Trying out a new method of collecting pruned input */
#include "wbc.h"

//
// Compile time switches
//
#ifdef _WIN32		/* Using Windows */
#define INPUTPATH "C:\\Temp\\sets.dat" // '\\' is required as an escape for shitty Windows design. We are really writing [C:\Temp\sets.dat].
#define OUTPUTPATH "C:\\Temp\\outset.dat"
#include "ccc.h"
#endif

#ifdef linux
#define INPUTPATH "sets.dat"
#define OUTPUTPATH "outset.dat"
#endif

using namespace std;	/* Standard Namespace */

//
// Public Variables
//
unsigned int mainSet[20] = {0};	/* Holds all elements of our set */
bool binary[20] = {0};
std::ifstream inputFile;
std::ofstream outputFile;

//
// Function Prototypes
//
int	openInput();
int	readInput();
int	openOutput ();
void 	printOutput (string input);
int 	getInputInt();
string 	getInputString();
int 	dispMenu();
int 	getLineLength();
int 	getSetCard();
int 	getPowerSetCard();
void 	printPowerSetBinary();

//
// Main
//
int main()
{
	int userChoice = 0;

	// Open sets.dat
	if (openInput())
	{
		cout << "Opened sets.dat" << endl;
	}
	else
	{
		cout << "Could not open sets.dat. Exiting." << endl;
		return(1); // Kill the program
	}
	
	// Read sets.dat
	if (readInput())
	{
		cout << "sets.dat read and closed" << endl;
	}
	else
	{
		cout << "Could not read sets.dat. Exiting." << endl;
		return(1); // Kill the program
	}

	// Open outset.dat
	if (openOutput())
	{
		cout << "Opened outset.dat";
	} else {
		cout << "Could not open outset.dat. Exiting." << endl;
		return(1); // Kill the program
	}
	
	// ENTERING MAIN LOOP
	// This will indefinitely collect user input and compute requested information on the set
	while (1)
	{

		stringstream line;

		// Print main menu and collect input
		userChoice = dispMenu();
		// Call function based on user input
		switch (userChoice)
		{
		case 1:
			line << endl << "Output Base Power Set selected." << endl;
			printOutput(line.str());
			printPowerSetBinary();
			break;
		case 2:
			line << endl << "Output Set Cardinality selected." << endl;
			line << "The base set cardinality is [" << getSetCard() << "]" << endl;
			printOutput(line.str());
			break;
		case 3:
			line << endl << "Output Power Set Cardinality selected." << endl;
			line << "The power set cardinality is [" << getPowerSetCard() << "]" << endl;
			printOutput(line.str());
			break;
		case 4:
			line << endl << "Quit selected. Program will now end." << endl;
			printOutput(line.str());
			outputFile.close();
			return (0); // End the program
			break;
		default:
			line << endl << "Error: input not recognized. Returning to menu." << endl;
			printOutput(line.str());
			break;
		} // end switch (userChoice)

		bcFlush(); // Flush the standard input

		cout << endl << "Selection completed. Hit [Enter] to return to [Main Menu]";
		getInputString();

	} // end while (1)
	return (0); // End of program
}

//
// Open the input file
//
// ABSTRACT
// Nothing
int openInput ()
{
	inputFile.open(INPUTPATH);
	return (inputFile.is_open());
}

//
// Read input file
//
// ABSTRACT
// We're using the standard fstream tools in C++.
// inputFile is type ifstream, will always open as input.
int readInput ()
{
	string line;
	int lineNum = 0;

	if (inputFile.is_open())
	{
		while (getline(inputFile,line))
		{
			mainSet[lineNum] = atoi(line.c_str());
			lineNum++;
		}
		inputFile.close();
	}

	// Print data
	cout << "Successfully read: ";
	for (int c = 0; mainSet[c] != 0; c++)
	{
		cout << "[" << mainSet[c] <<"] ";
	}
	cout << endl;

	inputFile.close();

	return (1);
}

//
// Open the output file
//
// ABSTRACT
// Nothing
int openOutput ()
{
	outputFile.open(OUTPUTPATH);
	return (outputFile.is_open());
}

//
// write output file
//
// ABSTRACT
// We're using the standard fstream tools in C++.
// Prints the string to both standard output and file stream.
void printOutput (string input)
{
	cout << input;
	outputFile << input;
}

//
// write output file
//
// ABSTRACT
// We're using the standard fstream tools in C++.
// Prints the string to file stream.
void writeOutput (string input_line)
{
	outputFile << input_line;
}

//
// Get user input [INTEGER]
//
// ABSTRACT
//
int getInputInt()
{
	string	local_string = "";
	int		local_int = 0;

	getline(std::cin, local_string);

	stringstream local_stream(local_string);

	if (local_stream >> local_int)
	{
		return local_int;
	} else {
		cout << "Error: Could not convert input to integer";
	}
	return 0;
}

//
// Get user input [ANY]
//
// ABSTRACT
//
string getInputString()
{
	string	local_string = "";

	getline(std::cin, local_string);

	return local_string;
}

//
// Display the Menu
//
// ABSTRACT
// It's an ascii menu.
int dispMenu ()
{
	int local_choice;

	// Clear/break screen
	#ifdef _WIN32
		clslow(); // Overwrite and clear console
	#else
		cout << endl << endl << endl;
	#endif

	// Print Menu Header
	cout << "========================================================" << endl;
	cout << "==================" << "  ACME CALCULATION  " << "==================" << endl;
	cout << "==================" << "   By: Chris Bero   " << "==================" << endl;
	cout << "==================" << "    [Main Menu]     " << "==================" << endl;
	cout << "[1] Output Power Set" << endl;
	cout << "[2] Output Base Set Cardinality" << endl;
	cout << "[3] Output Power Set Cardinality" << endl;
	cout << "[4] Quit" << endl;
	cout << endl << "You may pick a menu option [1-4]. \nType the number and then hit [Enter] to confirm." << endl;
	cout << ">_";

	// Get input
	local_choice = getInputInt();
	
	return (local_choice);
}

//
// Get a Power
//
// ABSTRACT
// Returns an integer of the form [base^power]
int getPower (int base, int power)
{
	int result = 1;
	for (int c = 0; c < power; c++)
	{
		result = result * base;
	}
	return(result);
}

//
// Print the Power Set with Binary tools
//
// ABSTRACT
// on hold
void printPowerSetBinary ()
{
	int setCard = getSetCard();
	int binaryLen = getPower(2, setCard);
	int col = 0;
	bool firstElem;
	stringstream line;

	line << "{" << endl; // Entire Power Set
	printOutput(line.str());
	line.str("");
	line.clear();

	for (int c = 0; c < binaryLen; c++)
	{
		if (c == 0 || col == 0)
		{
			line << "{"; // Element of power set
		} else {
			line << ", {"; // Element of power set
		}

		printOutput(line.str());
		line.str("");
		line.clear();

		for (int b = 0; b < 20; b++)
		{
			int mod = getPower(2, (b+1));
			int div = (mod/2);
			
			if (b == 0)
			{
				firstElem = true;
			}

			if ( ((c%mod)/div) >= 1)
			{
				binary[b] = 1;
			}
			else
			{
				binary[b] = 0;
			}

			if (binary[b] == 1)
			{
				if (firstElem)
				{
					line /*<< "{"*/ << mainSet[b] /*<< "}"*/;
					firstElem = false;
				} else {
					line /*<< ",{"*/ << "," << mainSet[b] /*<< "}"*/;
				}
			}

			printOutput(line.str());
			line.str("");
			line.clear();

		} // end inner for

		if (col < 4) {
			line << "}";
			col++;
		} else {
			line << "}," << endl;
			col = 0;
		}

		printOutput(line.str());
		line.str("");
		line.clear();

	} // end outer for
	
	line << endl << "}" << endl; // Entire Power Set

	printOutput(line.str());
	line.str("");
	line.clear();

}

//
// Print the main Set Cardinality
//
// ABSTRACT
// Normally, I'd opt for correctness, and count the set cardinality as it is read from the file.
// But, the directions specified churning through the whole set each time the function runs... So why not?
//
// We know from the program outline that input will only ever be values 1-99.
// This means that once we hit 0 in the main set array, we've reached the end of input data.
// The program outline also limits the number of input data to 20 elements.
int getSetCard ()
{
	int index = 0;
	while (mainSet[index] != 0 && index <= 19)
	{
		index++;
	}
	return(index);
}

//
// Print the Power Set Cardinality
//
// ABSTRACT
// We know from class notes that the power set cardinality may be determined from the base class.
// Power set cardinality is 2^k where k is the cardinality of the main set.
int getPowerSetCard ()
{
	int index = getSetCard();	// holds the main set's cardinality
	return(getPower(2, index));	// we already have a tool to create exponential integers, use it
}








