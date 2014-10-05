## General Notes
##### *for programming the stupendous MSP430*
##### Last updated: 5/10/2014

This markdown sheet is a list of notes taken by myself while
trying to figure out what the heck is going on
with this atrocity of msp programming.

#### Boards

	TI Experimenter Board (the POS used in lab)
	.----._.-----.
	|MSP430xG461x|
	|            |
	|        RST |-->
	|            |
	|       P1.0 |-->SW1 (labeled)
	|       P1.1 |-->SW2 (labeled)
	|            |
	|       P2.2 |-->LED1 (GREEN)
	|       P2.1 |-->LED2 (YELLOW)
	|            |
	|       P3.5 |-->Buzzer
	.____.-._____.

	TI Launchpad (the $10 one)
	.---._.-----.
	|MSP430G2231|
	|           |
	|       RST |-->
	|           |
	|      P1.0 |-->SW1 (labeled)
	|           |
	|      P2.2 |-->LED1 (GREEN)
	.___.-._____.

#### Personal Project Ideas
 
* Create project which works with the ~90ms brain delay
* Control a servo with a potentiometer

### General C Programming Points

* Make sure to encapsulate bitmask comparisons with () esp when using `&&` and `||`
	* This is done incorrectly on the sample programs, and you should fix it.
	* See page 48 in the Davies textbook. Seriously, read it.
* `#include <msp430.h>`
	* This is the correct way to include header files. Specify the model elsewhere.
	* Also done improperly in sample programs.
* `volatile` variables are ones which are changed outside the scope of the program.
	* These vars are kept in registers, and defeat a lot of optimizations.
	* They do not have to be used for interrupt service routines :D
* `&&` and `||` are boolean operators, meaning they operate on a value as a whole.
	* `&`(AND), `|`(OR), `^`(XOR), `~`(NOT) are bitwise operators, 
		* meaning they operate on each bit of a value.
* BIT0 - BIT7 are bit masks, with zeros everywhere except the specified location.
	* i.e. BIT3 = 00001000.

#### Bit Examples

	B = 1010
	A = 1001
	
	A & B = 1000
	A | B = 1011
	A ^ B = ????
	A ~ B = ????

### Bit Masks

	A Byte:
	[0] [0] [0] [0] [0] [0] [0] [0] = 0x00
	 7   6   5   4   3   2   1   0
	MSB                         LSB

### Common Bit Masks

* BIT0 through BITF
	* The digit corresponds to the '1' in a byte.
	* For instance, `BIT5 = [0] [0] [1] [0] [0] [0] [0] [0] = 0x20`
	* Read page 48 in the Davies textbook.

* Timer_A
	* TACLK: clock input to the timer
	* TA0 and TA1: either inputs or outputs
	* TACTL: Timer_A Control 

### Registers (consistent across msp devices)
* R0 / Program Counter / PC
	* Holds address of the next instruction.
* R1 / Stack Pointer / SP
	* Holds address of top of stack.
* R2 / Status Register / SR
	* Contains status flags.
* R3 / Constant Generator
	* Provides the six most frequently used values from RAM?
* R4 - R15
	* General Purpose Registers

### Clocks (somewhat consistent across msp devices)
* Master Clock [MCLK]
* Subsystem Master Clock [SMCLK}
* Auxiliary Clock [ACLK]

### IAR Bullshit (aka setup configs)
* Create a project, open the options window
* GENERAL
	* TARGET: Set device to MSP430FG4618
	* OUTPUT: Output file set to EXECUTABLE
	* LIBRARY CONFIGURATION: LIBRARY set to NONE (ASM) or NORMAL DLIB (C)
* C COMPILER
	* OPTIMIZATIONS: LEVEL set to NONE
	* OUTPUT: GENERATE DEBUG INFORMATION
	* LIST: OUTPUT LIST FILE and ASSEMBLER MNEMONICS checked
* ASSEMBLER
	* LIST: OUTPUT LIST FILE checked
* LINKER
	* OUTPUT: DEBUG INFORMATION FOR CSPY and RUNTIME CONTROL MODULES and I/O EMULATION checked
	* LIST: GENERATE LINKER LISTING and SEGMENT MAP and MODULE MAP
* DEBUGGER
	* SETUP: DRIVER set to SIMULATION
	* FET debugging: set speed to max and turn on validation.

### MSP Naming Convention
- MSP: Mixed Signal Processor
- The letter after msp430 indicates type of memory.
	- F: Flash memory
	- C: ROM
- A second letter shows the type of intended measurement:
	- E: Electricity
	- W: Water
	- G: Signals (which require a gain stage by an op amp?)
- The next digit indicates family, and the final two or three detail the specific device
	- MSP430x1xx: General Purpose
	- MSP430F2xx: Newer, general purpose line (2005). Runs at 16Mhz, uses less power. Comes in DIP packages!
	- MSP430x3xx: Original family, obsolete.
	- MSP430x4xx: Can drive LCDs, has a lot of pins usually.
	- MSP430X: Original architecture. A part of the F2xx and F4xx lines.

#### Lab devices
- MSP430FG4618: Flash memory, signal processing, can drive LCDs and has many pins.
- MSP430G2231: Unknown memory? Signal processing.






























