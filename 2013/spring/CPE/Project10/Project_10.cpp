/*********************************************
 * Program Title: Classes 'n Stuff
 * Project File: Project_10.cpp
 * Name: Christopher Bero
 * Course Section: CPE-112-03
 * Lab Section: 01
 * Due Date: 01/22/13
 * program description: Description of
 * What the program does.
 *********************************************/

/*
 * Include Statements
 */
#include <iostream>
#include <string>
#include <iomanip>
#include <fstream>

/*
 * Namespace definition
*/
using namespace std;

struct matrix {
int m11;
int m12;
int m21;
int m22;
};

/**
 * Function Prototypes
 */
int openFile (string fileName, ifstream& inputStream);
void readFile (ifstream& inputStream, matrix& mA, matrix& mB);
matrix addMatrix (matrix mA, matrix mB);
matrix subMatrix (matrix mA, matrix mB);
matrix multMatrix (matrix mA, matrix mB);
void printMatrix (matrix m);

/*
 * Main function
 */
int main()
{

string fileName;
ifstream inputStream;

matrix mA;
matrix mB;

do {
cout << endl << endl << "Enter the name of the input file now: ";
cin >> fileName;
cout << fileName << endl;
} while (openFile(fileName, inputStream) != 0);

readFile(inputStream, mA, mB);

cout << endl << string(30, '-');
cout << endl << "Matrix C = Matrix A + Matrix B";
cout << endl << string(30, '-');
printMatrix(addMatrix(mA, mB));
cout << endl << string(30, '-') << endl;

cout << endl << string(30, '-');
cout << endl << "Matrix C = Matrix A - Matrix B";
cout << endl << string(30, '-');
printMatrix(subMatrix(mA, mB));
cout << endl << string(30, '-') << endl;

cout << endl << string(30, '-');
cout << endl << "Matrix C = Matrix A * Matrix B";
cout << endl << string(30, '-');
printMatrix(multMatrix(mA, mB));
cout << endl << string(30, '-') << endl;

cout << endl << string(30, '-');
cout << endl << "Matrix C = Matrix B * Matrix A";
cout << endl << string(30, '-');
printMatrix(multMatrix(mB, mA));
cout << endl << string(30, '-') << endl << endl;

return (0);
} //end main


matrix addMatrix (matrix mA, matrix mB)
{
matrix mC;
mC.m11 = mA.m11 + mB.m11;
mC.m12 = mA.m12 + mB.m12;
mC.m21 = mA.m21 + mB.m21;
mC.m22 = mA.m22 + mB.m22;
return (mC);
}

matrix subMatrix (matrix mA, matrix mB)
{
matrix mC;
mC.m11 = mA.m11 - mB.m11;
mC.m12 = mA.m12 - mB.m12;
mC.m21 = mA.m21 - mB.m21;
mC.m22 = mA.m22 - mB.m22;
return (mC);
}

matrix multMatrix (matrix mA, matrix mB)
{
matrix mC;
mC.m11 = (mA.m11*mB.m11)+(mA.m12*mB.m21);
mC.m12 = (mA.m11*mB.m12)+(mA.m12*mB.m22);
mC.m21 = (mA.m21*mB.m11)+(mA.m22*mB.m21);
mC.m22 = (mA.m21*mB.m12)+(mA.m22*mB.m22);
return (mC);
}

void printMatrix (matrix m)
{
cout << endl << setw(6) << left << m.m11 << m.m12;
cout << endl <<setw(6) << left << m.m21 << m.m22;
}

int openFile (string fileName, ifstream& inputStream)
{
inputStream.open(fileName.c_str());
if (inputStream.fail())
{
cout << endl << string(11, '*') << "  File Open Error  " << string(11, '*');
cout << endl << "==> Input file failed to open properly!!";
cout << endl << "==> Attempted to open file: " << fileName;
cout << endl << "==> Please try again...";
cout << endl << string(41, '*');
return (1);
} //end if
return (0);
} //end openFile

void readFile (ifstream& inputStream, matrix& mA, matrix& mB)
{
cout << endl << "Loading values for Matrix A...";
inputStream >> mA.m11 >> mA.m12 >> mA.m21 >> mA.m22;
if (inputStream.fail())
{
cout << endl << endl << string(10, '*') << "  Load Matrix Error  " << string(10, '*');
cout << endl << "==> Error in input file.";
cout << endl << "==> Unable to load matrix.";
cout << endl << "==> Either a character is present, or";
cout << endl << "==> not enough information is present.";
cout << endl << "==> Terminating the program....";
cout << endl << string(41, '*') << endl << endl;
exit(1);
}
else {
cout << endl << string(8, '-');
cout << endl << "Matrix A";
cout << endl << string(8, '-');
cout << endl << setw(6) << left << mA.m11 << mA.m12;
cout << endl << setw(6) << left << mA.m21 << mA.m22;
cout << endl << string(8, '-') << endl;
}

cout << endl << "Loading values for Matrix B...";
inputStream >> mB.m11 >> mB.m12 >> mB.m21 >> mB.m22;
if (inputStream.fail())
{
cout << endl << endl << string(10, '*') << "  Load Matrix Error  " << string(10, '*');
cout << endl << "==> Error in input file.";
cout << endl << "==> Unable to load matrix.";
cout << endl << "==> Either a character is present, or";
cout << endl << "==> not enough information is present.";
cout << endl << "==> Terminating the program....";
cout << endl << string(41, '*') << endl << endl;
exit(1);
}
else {
cout << endl << string(8, '-');
cout << endl << "Matrix B";
cout << endl << string(8, '-');
cout << endl << setw(6) << mB.m11 << mB.m12;
cout << endl << setw(6) << mB.m21 << mB.m22;
cout << endl << string(8, '-') << endl;
}

} //end readFile



















