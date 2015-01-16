//**************************************************************************
//  Description: Toggle LED1 on P2.2 using software timed by the WDT ISR. 
//  In this example the WDT configured as simple interval timer,
//  and it is clocked with fSMCLK, where fSMCLK = 1 MHz.
//  Time interval is defined as 32,768*1/fACLK = 32,768 us = 32ms;
//  The WDT ISR counts by (31.25*32ms = 1s).
//
//                 MSP430xG461x
//             -----------------
//        /|\ |              XIN|-
//         |  |                 | 32kHz
//         ---|RST          XOUT|-
//            |                 |
//            |                 |
//            |             P2.2|--> LED1
//            |                 |
//            |                 |
//            |                 |
//
//  @A. Milenkovic, milenkovic@computer.org
//   Max Avula, ma0004@uah.edu
//**************************************************************************
#include <msp430xG46x.h>

void main(void)
{
  WDTCTL = WDT_MDLY_32;	                // 32ms interval (default) 
  P2DIR |= BIT2;                        // Set P2.2 to output direction
  IE1 |= WDTIE;                         // Enable WDT interrupt

  _BIS_SR(LPM0_bits + GIE);             // Enter LPM0 w/ interrupt
}

// Watchdog Timer interrupt service routine
#pragma vector=WDT_VECTOR
__interrupt void watchdog_timer(void)
{
  static int i = 0;
  i++;
  if (i == 32) {		// 1 second on, 1 second off 31.25 * 32 ms = 1s
    P2OUT ^= BIT2;   	// Toggle P2.2 using exclusive-OR
    i = 0;
  }
}
