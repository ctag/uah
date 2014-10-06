/***********************************************************************
 * MSP430 Experimenter Board Header File
 * By: Christopher 'ctag' Bero
 * 
 **********************************************************************/

/* includes:
 * #include <msp430.h>		// Main
 * #include <intrinsics.h>	// Something?
 * #include <stdint.h>		// Specific length variables
 */
 
/*
 * Switches
 * Usage:
 * if (SW1 == 0) // SW1 is pressed
 */
#define SW1 (BIT1&P1IN)	// P1.0 switch SW1 
#define SW2 (BIT2&P1IN)	// P1.1 switch SW2

// LEDs
#define LED1 = () // P2.2 - Green
#define LED2 = () // P2.1 - Yellow
#define LED3 = () // P1.0/TACLK/ACLK - Red (JP2)
#define LED4 = () // P5.1 - Red (JP3)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 