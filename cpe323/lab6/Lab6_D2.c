/****************************************************************************
;   MSP430xG46x Demo - Interfacing Switch
;   Description: This program will keep LED1 ON as long as the switch SW1 is
;	pressed and turn it OFF as soon as the switch is released. This is
;	achieved by checking conditions for the switch state (pressed/released).
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

#define SW1 BIT0&P1IN    					// B1 - P1.0 switch SW1 

void main(void) 
{ 
	int i;
	P2DIR |= 0x04;							// Set LED1 as output 
  	for(;;) {     
    	if ((SW1) == 0)        				// if SW1 is pressed 
      	{ 
      		for(i=1000; i > 0; i--);  		// Make sure it is indeed pressed 
      		if((SW1) == 0)
			{
				P2OUT |= 0x04; 				// LED1 stays ON
			}
      		while((SW1)==0);  				// Wait until SW1 is released
				P2OUT &= ~0x04; 			// LED1 stays OFF
      	}
    } 
} 
