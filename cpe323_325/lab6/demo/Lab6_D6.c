/*****************************************************************************
;   TI Experimenter board demo, blinking leds LED1 and LED2 (msp430FG4618)
;
;   Description: Toggle P2.1 and P2.2 by xoring P2.1 and P2.2 inside a loop. 
;                The leds are connected to P2.1 and P2.2 and are on when
;                P2.1=1 and P2.2=1; 
;                The LEDs are initialized P2.1 to be off, and P2.2 to be on;
;                ACLK = 32.768kHz, MCLK = SMCLK = default DCO
;
;                 MSP430xG461x
;             -----------------
;         /|\|                 |
;          | |                 |
;          --|RST              |
;            |             P2.2|-->LED1(GREEN)
;            |             P2.1|-->LED2(YELLOW)
;
;   Alex Milenkovich, milenkovic@computer.org
;***************************************************************************/
#include  <msp430xG46x.h>
void main(void) 
{ 
   WDTCTL = WDTPW + WDTHOLD;// Stop watchdog timer 
   P2DIR |= 0x06; 		    // Set P2.1 and P2.2 to output direction (0000_0110) 
   P2OUT = 0x02; 			// Set P2OUT to 0000_0010b (LED2 is ON, LED1 is OFF)
     for (;;) { 
     unsigned int i; 
     P2OUT ^= 0x06; 		// Toggle P2.1 and P2.2 using exclusive-OR 
     i = 50000; 		    // Delay 
     do (i--); 
     while (i != 0); 
   } 
}
