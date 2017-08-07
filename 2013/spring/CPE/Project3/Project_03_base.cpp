//******************************************************************
// The following is a partial header comment block.  Modify the
// appropriate parts by putting in your information.  Look at
// the samples handed out to make any necessary additions
// You may delete this line and the three above it.
// Program: project 3 source code for modification
// Name: MODIFICATION #0                                   <<============
// CPE112, Lab Section MODIFICATION #0                     <<============
// Project due date: MODIFICATION #0                       <<============
// This program has two parts associated with it.  The students
// modify the source code to improve upon the existing code and 
// to learn some aspects of writing C++ code.
//******************************************************************
// Put all preprocessor directives here
// The following are the necessary header files
#include <iostream> // header file for standard input output 

// PUT MODIFICATION  #1 here in place of this comment statement  <<============

using namespace std;

/* This function calculates the pay in one of two ways */
/* depending on the hours worked			*/
void CalcPay( float, float, float& );

// Global constant declarations
const float MAX_HOURS = 40.0;   // Maximum normal work hours
const float OVERTIME = 1.5;     // Overtime pay rate factor

int main()
{
    // ################################################
    // variable Declarations for Part I of the program
    // ################################################
    float payRate;       // Employee's pay rate
	float hours;         // Hours worked
	float wages;         // Wages earned based on pay rate and hours worked.
	int   empNum;        // Employee ID number
	// PUT MODIFICATION  #2 here in place of this comment  <<============
	
	// ################################################
    // variable Declarations for Part II of the program
   	int   partNumber;		// Unique part number
	int   quantity;		// Quantity of parts ordered
	float unitPrice;		// Price per part
	float partsPrice;		// Price of these particular parts
	// PUT MODIFICATION #5 here in place of this comment  <<=================
	// ################################################
	
	// ################################################
	// ####### Start of part 1 of the program  ########
	// ################################################
	// This part of the program is a wage calculation program
 
	
    cout << "\n----------------------------------\n";
	cout << "===> Start of Part I output <===\n";
    cout << "----------------------------------\n\n";

	// prompt for and read in the information for an employee
	// information read is the employee number, their pay rate 
	// and the number of hours they have worked for the week.
	cout << "Enter the employee number: "; 
    cin >> empNum; 
    cout << empNum << endl;                         
    cout << "Enter pay rate: ";            
    cin >> payRate; 
    cout << payRate << endl;                      
    cout << "Enter hours worked: ";      
    cin >> hours;
    cout << hours << endl;  
    cout << endl; // print out a blank line

	

	CalcPay(payRate, hours, wages);         // call the function that Compute wages

	// output the employee information and the results
	// note how the output statement is broken up into multiple lines so that
	// the cout statement is not too long.

	// PUT MODIFICATION  #3 here in place of these two comment lines.  This   <<============
	// modification adds an if statement to calculate regular and overtime pay

	// PUT MODIFICATION #4 here in place of these 2 comment statemnents.  <<============
	// Also, Delete the 4 line cout statement shown below this comment.

	cout << "Employee: " << empNum << endl;   // remove this line for mod #4  <<============
	cout << "Pay rate: " << payRate << endl;  // remove this line for mod #4  <<============
	cout << "Hours: " << hours << endl;       // remove this line for mod #4  <<============
	cout << "Wages: $" << wages << endl;      // remove this line for mod #4  <<============
	
    // keep the following cout statement
	cout << "\n===> End of part I output <===\n";
    cout << "----------------------------------\n\n";

	// ################################################################
	// ################################################################
	// ###########  END of the first part of the program ##############
	// ################################################################
	// ################################################################

	// ############################################################
	// ################### start of second part of the program ####
	// ############################################################
	// This part of the program calculates the total price of parts 
	// entered and itemizes the bill in the output

	cout << "----------------------------------\n";
	cout << "===> Start of Part II output <===\n";
    cout << "----------------------------------\n";

	// Set up floating-point output format	
	// MODIFICATION #6 replaces this comment line and the line below  <<============
	cout << fixed << showpoint;  // replace this line with Modification #6

	// PUT MODIFICATION #7 here in place of this comment  <<============

	// PUT MODIFICATION #8 here in place of this comment  <<============
	cout << "Enter the part number:"; // delete this line for modification #8
	cin >> partNumber;     // Read in the first part number
	cout << partNumber << endl;

	// PUT MODIFICATION #9 here in place of this comment  <<============
	
	cout << "Enter the quantity of this part ordered:"; // Prompt
	cin >> quantity;
	cout << quantity << endl;

	cout << "Enter the unit price for this part:";      // Prompt
	cin >> unitPrice;
	cout << unitPrice << endl;

	partsPrice = quantity * unitPrice;
	cout << "Part " << partNumber                      // Echo print
		<< ", quantity " << quantity
		<< ", at $" << unitPrice << " each totals $"
		<< partsPrice << endl;

	// PUT MODIFICATION #10 here in place of this comment  <<============

	// PUT MODIFICATION #11 here in place of this comment  <<============
	
	cout << "\n===> End of part II output <===\n";
    cout << "----------------------------------\n\n";
	return 0;     // Indicate successful completion of the program
}                                           

//******************************************************************
//******************************************************************
//     All function definitions are placed below main
//******************************************************************
//******************************************************************

void CalcPay( /* in */  float  payRate,     // Employee's pay rate
		/* in */  float  hours,       // Hours worked
		/* out */ float& wages )      // Wages earned

// CalcPay computes wages from the employee's pay rate
// and the hours worked, taking overtime into account

{
	if (hours > MAX_HOURS)                     // Is there overtime?
		wages = (MAX_HOURS * payRate) +        // Yes
			(hours - MAX_HOURS) * payRate * OVERTIME;
	else
		wages = hours * payRate;               // No
}
