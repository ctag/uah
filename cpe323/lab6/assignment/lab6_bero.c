/***************************************************************************************
 *   TI Experimenter board demo, lab6
 *
 *   Description: This program closely follows the guidelines set for
 *						it in the Lab6 pdf manual.
 *						SW1 and SW2 are interrupt enable and each affects
 * 						the controller's clock to adjust a blink rate of LED1&2
 *
 *                 MSP430xG461x
 *             -----------------
 *       /|\  |                 |
 *        |   |                 |
 *        \---|RST           |
 *            |          P1.0|-->SW1
 *            |          P1.1|-->SW2
 *            |                 |
 *            |          P2.2|-->LED1(GREEN)
 *            |          P2.1|-->LED2(YELLOW)
 *
 *   Christopher Bero <csb0019@uah.edu>
 **************************************************************************************/

#include  <msp430xG46x.h>

#define SW1 0x01&P1IN		// B1 - P1.0 switch SW1 
#define SW2 0x02&P1IN		// B2 - P1.1 switch SW2

volatile int timerCount = 0;
volatile int previousClock = 60;
volatile short int sw2interrupt = 0;

void main(void) 
{ 
   if (SCFQCTL == 60)
		{
			SCFQCTL = 30;			// Set clock to 1Mhz
		}WDTCTL = WDTPW + WDTHOLD;		// Stop watchdog timer 

	FLL_CTL0 |= XCAP18PF;	// Set load capacitance for xtal
	SCFI0 |= FN_2;					// x2 DCO, 4MHz nominal DCO
	SCFQCTL = 60;					// (60+1) x 32768 ~~ 2 MHz
   
	P2DIR |= 0x06; 		    // Set P2.1 and P2.2 to output direction (0000_0110) 
	P2OUT = 0x02; 		// Set P2OUT to 0000_0010b (LED2 is ON, LED1 is OFF)
	
	// Screw the loops, we're using TimerA to control out LEDs
	TA0CCR0 |= 40000-1;		// See below
		// ACLK ~ 33KHz & SMCLK ~ 2MHz
		// So we trigger every 32,768 clicks to achieve 1Hz blink (1 second on, 1 second off) with ACLK
		// Or every 2,000,000 clicks for SMCLK (the one we have to use)
		// The register value cannot exceed ~60,000, so we must use 40,000 and count to 50
		// But we really want a 2Hz blink (0.5 sec on, 0.5 sec off), so we only count to 25
	TA0CCTL0 |= CCIE;		// Enable the clock interrupt
	TA0CTL |= TASSEL_2 + MC_1;		// Choose SMCLK as the clock, change to TASSEL_1 for ACLK	

	_EINT();					// Enable interrupts
	P1IE |= 0x0003;				// P1.0 interrupt enabled
	P1IES |= 0x0003;			// P1.0 hi -> low edge
	P1IFG &= ~0x0003;		// Clear P1.0 IFG
	
	// P1IE |= BIT0;				// P1.1 interrupt enabled
	// P1IES |= BIT0;			// P1.1 hi -> low edge
	// P1IFG &= ~BIT0;		// Clear P1.1 IFG
	
	for (;;) { 
		if ((SW2) != 0 && (sw2interrupt == 1))
		{
			SCFQCTL = previousClock;
                        sw2interrupt = 0;
		}
	}

}

// Port 1 interrupt service
#pragma vector = PORT1_VECTOR
__interrupt void Port1_ISR (void)
{
	if ((SW1) == 0 && (SW2) != 0)
	{
		if (SCFQCTL == 60)
		{
			SCFQCTL = 120;			// Set clock to 4Mhz
		} 
		else if (SCFQCTL == 120)
		{
			SCFQCTL = 60;			// Set clock to 2Mhz
		}
	}
	
	if ((SW2) == 0 && (SW1) != 0)
	{
		previousClock = SCFQCTL;
		sw2interrupt = 1;
                
		SCFQCTL = 30;			// Set clock to 1Mhz
		
		// while ((SW2) == 0)
		// {
			
		// }
		
		// SCFQCTL = previousClock;
	}
		P1IFG &= ~BIT1;		// Clear P1.0 IFG
		P1IFG &= ~BIT0;		// Clear P1.0 IFG
}

// TimerA interrupt service
#pragma vector=TIMER0_A0_VECTOR
   __interrupt void Timer0_A0 (void) {
 
    timerCount++;
	
	if (timerCount == 25)
	{
		P2OUT ^= 0x06;
		timerCount = 0;
	}
}





















