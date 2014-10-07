/***********************************************************************
 * Title: TEST - Watchdog Reset
 * Date Due: NEVAR!
 * 
 * Description:
 * This program 
 *
 * By: Christopher 'ctag' Bero <csb0019@uah.edu>
 * Project: https://github.com/ctag/uah
 *
 * This software is licensed under the GPLv3,
 * consult the LICENSE file for more information.
 **********************************************************************/

#include <msp430.h> // The *correct* include statement

#define SW1 (BIT0&P1IN)	// B1 - P1.0 switch SW1 
#define SW2 (BIT1&P1IN)	// B2 - P1.1 switch SW2

#define LED1 BIT2;
#define LED2 BIT1;

// Another way of doing what's below
// Usage: WDTCTL = WDTCONFIG;
#define WDTCONFIG (WDTPW|WDTCNTCL|WDTSSEL)

void main(void)
{
	// We want a 1s watchdog. So,
	// Clock: ACLK = 32,768 Hz. WDTSSEL = 1.
	// Interval: 1 Hz = 32,768Hz / 32,768 cycles. WDTISx = 0x00, or 32,768 cycles.
	WDTCTL = (WDTPW|WDTCNTCL|WDTSSEL);
	
	P2DIR |= LED1;
	P2DIR |= LED2;
	
	P2OUT = LED1;
	
	P1IE |= 0x0003;		// P1.0 interrupt enabled
	P1IES |= 0x0003;	// P1.0 hi -> low edge
	P1IFG &= ~0x0003;	// Clear P1.0 IFG
	
	for (unsigned int i = 0; i < 60000; i++)
	{
		asm("NOP");
	}
	
	P2OUT ^= LED1;
	
	_EINT();			// Enable interrupts
	//__enable_interrupt(); // Same as _EINT()?
	
	//IE1 |= WDTIE;                     // Enable WDT interrupt
	//_BIS_SR(LPM0_bits + GIE);         // Enter LPM0 w/ interrupt

	
	
	while (1)
	{
		asm("NOP");
		WDTCTL = WDTCONFIG;
	}
}

/*
 * Watchdog Timer interrupt service routine
 */
#pragma vector = WDT_VECTOR
__interrupt void watchdog_timer(void)
{

}

/*
 * Port 1 interrupt service routine
 */
#pragma vector = PORT1_VECTOR
__interrupt void Port1_ISR (void)
{
	// Constant delay debounce
	//int factor = (SCFQCTL / 30);
	//int looper = (20 * factor);
	//for (int c = 0; c < looper; c++)
	//{ asm("NOP"); }
        
      P2OUT = LED2;
  
	if (((SW1) == 0) && ((SW2) != 0)) // SW1 is pressed
	{
		while (((SW1) == 0) && ((SW2) != 0))
		{
			asm("NOP");
		}
	} else if (((SW2) == 0) && ((SW1) != 0)) // SW2 is pressed
	{
	
	}

        P2OUT ^= LED2;
        
	P1IFG &= ~BIT1;		// Clear P1.1 IFG
	P1IFG &= ~BIT0;		// Clear P1.0 IFG
}





























