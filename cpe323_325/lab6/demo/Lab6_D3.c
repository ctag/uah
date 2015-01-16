/****************************************************************************
;   MSP430xG46x Demo - Interrupt driven interfacing Switch
;   Description: This program will keep LED1 ON as long as the switch SW1 is
;	pressed and turn it OFF as soon as the switch is released. This is
;	achieved by checking conditions for the switch state (pressed/released).
;	When the switch is pressed, a port 1 interrupt is generated and the program
;	executes the code in the interrupt vector to turn ON LED1. LED1 stays on 
;	until the switch is released. The release of the switch clears the interrupt
;	vector and LED1 is turned OFF immediately.
;
;   ACLK = 32.768kHz, MCLK = SMCLK = 1 MHz
;                 MSP430xG461x
;             -----------------
;         /|\|                 |
;          | |                 |
;          --|RST          P1.0|-->SW1
;            |                 |
;            |             P2.2|-->LED1
;   Alex Milenkovich, milenkovic@computer.org
;   Max Avula, ma0004@uah.edu
;***************************************************************************/
#include  <msp430xG46x.h> 

#define SW1 BIT0&P1IN               // B1 - P1.0 switch SW1 

void main(void) 
{ 
	WDTCTL = WDTPW+WDTHOLD;     // Stop WDT
    P2DIR |= 0x04;		    // Set LED1 as output
	P2OUT = 0x00;		    // clear LED1 status
  	_EINT();                    // enable interrupts
	P1IE |= BIT0;               // P1.0 interrupt enabled
	P1IES |= BIT0;              // P1.0 hi/low edge
	P1IFG &= ~BIT0;             // P1.0 IFG cleared
    for(;;) 
    {     
		while((SW1)== 0);  		// Wait until SW1 is released
        P2OUT &= ~0x04; 	// LED1 stays OFF
    } 
} 

// Port 1 interrupt service routine
#pragma vector = PORT1_VECTOR
__interrupt void Port1_ISR (void)
{  
    P2OUT |= 0x04;			// LED1 stays ON
    P1IFG &= ~BIT0;       // P1.0 IFG cleared
}