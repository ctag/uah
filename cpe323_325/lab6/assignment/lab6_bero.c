/***********************************************************************
 *   lab6, TI experimenter board project
 *
 *   Desc:	This program closely follows the guidelines set for
 *			it in the Lab6 pdf manual.
 *			SW1 and SW2 are interrupt enabled and each affects
 * 			the controller's clock to adjust the blink rate of LED1/2
 *
 *   .----._.-----.
 *   |MSP430xG461x|
 *   |            |
 *   |        RST |-->
 *   |            |
 *   |       P1.0 |-->SW1 (labeled)
 *   |       P1.1 |-->SW2 (labeled)
 *   |            |
 *   |       P2.2 |-->LED1 (GREEN)
 *   |       P2.1 |-->LED2 (YELLOW)
 *   |            |
 *   |       P3.5 |-->Buzzer
 *   |            |
 *   \____________/ 
 * 
 *   Christopher Bero <csb0019@uah.edu>
 **********************************************************************/

// Here's to the day that IAR is able to format .c files correctly.
// Don't hold your breath.

#include  <msp430.h> 	// The /correct/ way to include standard library

#define SW1 0x01&P1IN	// B1 - P1.0 switch SW1 
#define SW2 0x02&P1IN	// B2 - P1.1 switch SW2

// Volatile variables may be changed at any time by a subroutine (interrupt)
volatile short int timerCount = 0;			// Number of times TimerA has been triggered
volatile short int previousClock = 60;		// The clock factor to return to after SW2 interrupt
volatile short int sw2Interrupt = 0;	// Status boolean, are we in a modified clock state?
										// 0 = no; 1 = yes;
/*
 * Main function (infinite loop, no exit)
 */
void main ( void ) 
{
	WDTCTL = WDTPW + WDTHOLD;	// Stop watchdog timer 

	FLL_CTL0 |= XCAP18PF;	// Set load capacitance for xtal
	SCFI0 |= FN_2;			// x2 DCO, 4MHz nominal DCO
	SCFQCTL = 60;			// (60+1) x 32768 ~= 2 MHz
	
	P2DIR |= 0x06;		// Set P2.1 and P2.2 to output direction (0000_0110) 
	P2OUT = 0x02; 		// Set P2OUT to 0000_0010b (LED2 is ON, LED1 is OFF)
	
        P5DIR |= 0x02;          // Pin 5, on P5.1, a red LED, cool.
        P5OUT = 0x00;           // Let's use it! (needs jumper JP3 bridged)
        
	// Screw looping, use TimerA and SMCLK to control LEDs
	TA0CCR0 |= 40000-1;	// See below
		// ACLK ~ 33KHz & SMCLK ~ 2MHz
		// So we trigger every 32,768 clicks to achieve 1Hz blink (1 second on, 1 second off) with ACLK
		// Or every 2,000,000 clicks for SMCLK (the one we have to use)
		// The register value cannot exceed ~60,000, so we must use 40,000 and count to 50
		// But we really want a 2Hz blink (0.5 sec on, 0.5 sec off), so we only count to 25
	TA0CCTL0 |= CCIE;			// Enable the clock interrupt
	TA0CTL |= TASSEL_2 + MC_1;	// Choose SMCLK as the clock, change to TASSEL_1 for ACLK	

	_EINT();			// Enable interrupts
	P1IE |= 0x0003;		// P1.0 interrupt enabled
	P1IES |= 0x0003;	// P1.0 hi -> low edge
	P1IFG &= ~0x0003;	// Clear P1.0 IFG
	
	while (1) 
	{
		// Coming out of a SW2 interrupt once button is released
		if (((SW2) != 0) && (sw2Interrupt == 1))
		{
			SCFQCTL = previousClock;
			sw2Interrupt = 0;
		}
	}
}

/*
 * Port 1 interrupt service
 */
#pragma vector = PORT1_VECTOR // The fuck does pragma mean? or vector for that matter.
__interrupt void Port1_ISR (void)
{
	// Constant delay debounce, arbitrary looper value
  // At SCFQCTL=30, we delay 20 NOP instructions.
  // At SCFQCTL=60, we delay 40 NOP instructions.
  // At SCFQCTL=120, we delay 80 NOP instructions.
  // A linear relationship between clock and delay :)
	int factor = (SCFQCTL / 30);
	int looper = (20 * factor);
	
	for (int c = 0; c < looper; c++)
	{
		asm("NOP");
	}
  
	if (((SW1) == 0) && ((SW2) != 0))
	{
		if (SCFQCTL == 60)
		{
			SCFQCTL = 120;	// Set clock to 4Mhz
		} 
		else if (SCFQCTL == 120)
		{
			SCFQCTL = 60;	// Set clock to 2Mhz
		}
	}
	else if (((SW2) == 0) && ((SW1) != 0) && (sw2Interrupt == 0))
	{
		previousClock = SCFQCTL;
		sw2Interrupt = 1;
		SCFQCTL = 30;	// Set clock to 1Mhz
	}
	
	P1IFG &= ~BIT1;		// Clear P1.1 IFG
	P1IFG &= ~BIT0;		// Clear P1.0 IFG
}

/*
 * TimerA interrupt service
 */
#pragma vector=TIMER0_A0_VECTOR
__interrupt void Timer0_A0 (void) 
{
	// Blink LED4 once every other time the interrupt is called.
	// Freq = interrupt/4
	if ((timerCount % 2) == 1)
	{
		P5OUT ^= 0x02;
	}
    
	timerCount++;
	
	// Blink LED1 + LED2
	// Freq = interrupt/25
	if (timerCount == 25)
	{
		P2OUT ^= 0x06;
		timerCount = 0;
	}
}





























