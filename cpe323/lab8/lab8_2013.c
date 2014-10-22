/***********************************************************************
 * Title: Lab 8 - 2013 part
 * Date Due: Oct sometime
 * 
 * Description:
 * 
 *
 * By: Christopher 'ctag' Bero <csb0019@uah.edu>
 * Project: https://github.com/ctag/uah
 *
 * This software is licensed under the GPLv3,
 * consult the LICENSE file for more information.
 **********************************************************************/

#define PORT1_7 = (P1IN&0x07)

#include <msp430.h> // The *correct* include statement

void main(void)
{
	//WDTCTL = WDT_ADLY_250;
	WDTCTL = (WDTPW|WDTHOLD);
	
	P1DIR &= ~BIT8; // Set P1.7 as input
	P1DIR |= BIT0; // LED3 as output
	P1OUT &= ~BIT0; // LED off
	
	//_EINT();			// Enable interrupts
	//__enable_interrupt(); // Same as _EINT()?
	
	//IE1 |= WDTIE;                     // Enable WDT interrupt
	//_BIS_SR(LPM0_bits + GIE);         // Enter LPM0 w/ interrupt

	while (1)
	{
		if ((PORT1_7) != 0)
		{
			P1OUT &= ~BIT0; // LED off
			while ((PORT1_7 != 0)
			{
				asm("NOP");
			}
		}
		P1OUT |= BIT0; // LED on
	}
}

