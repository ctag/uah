/***********************************************************************
 * Title: TEST - Watchdog Reset (without interrupts)
 * Date Due: NEVAR!
 * 
 * Description:
 * This program will blink LED1 for a short period,
 * then settle down and keep the watchdog happy.
 * When SW1 is held, the watchdog is not taken care of,
 * and if the switch is held for > 1s, the timer will overflow
 * and the system will reset with a POR (I think).
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

#define LED1 BIT2; // LED1 - P2.2 - 0x04
#define LED2 BIT1; // LED2 - P2.1 - 0x02

// Usage: WDTCTL = WDT_CONFIG;
#define WDT_CONFIG (WDTPW|WDTCNTCL|WDTSSEL) // Set bits to give us 1s watchdog
#define WDT_HALT (WDTPW|WDTHOLD) // Set bits to halt the timer

void blinky (); // function prototype, defined below main()

void main(void)
{
	WDTCTL = WDT_HALT; // Stop the watchdog, see #define above
	
	P2DIR |= LED1; // Set LED1 to be output
	P2DIR |= LED2; // Set LED2 to be output
	
	P2OUT = 0x0; // Turn off both LEDs
	
	P1IE |= 0x0003;		// P1.0 interrupt enabled
	P1IES |= 0x0003;	// P1.0 hi -> low edge
	P1IFG &= ~0x0003;	// Clear P1.0 IFG
	
	blinky(); // Blink LED1
	
	// We want a 1 second watchdog. So,
	// Clock: ACLK = 32,768 Hz. WDTSSEL = 1.
	// Interval: 1 Hz = 32,768Hz / 32,768 cycles. WDTISx = 0x00, or 32,768 cycles.
	WDTCTL = (WDTPW|WDTCNTCL|WDTSSEL);
	
	while (1)
	{
		if (SW1 == 0)
		{
			while (SW1 == 0)
			{
				P2OUT = LED2;
			}
		}
		P2OUT &= ~LED2;
		WDTCTL = WDT_CONFIG;
	}
}

void blinky (void)
{
	// SCFQCTL defaults to 31.
	// MCLK = (SCFQCTL + 1) * ACLK
	int counter = (1000 * SCFQCTL); // Make our delays scale with MCLK
	int blinks = 8; // Number of times to blink the LED1 * 2
	
	P2OUT &= ~LED1; // LEDx is defined at top of program
	
	for (int c = 0; c < blinks; c++)
	{
		P2OUT ^= LED1;
		for (unsigned int i = 0; i < counter; i++)
		{
			//asm("NOP");
			WDTCTL = WDT_CONFIG; // Defined at top of program
		}
	}
}



























