//**************************************************************************
//  Description: Toggle LED1 on P2.2 using software timed by the WDT ISR. 
//  In this example the WDT is configured in interval timer mode,
//  and it is clocked with fACLK, where fACLK = 32,768 Hz.
//  The WDT ISR toggles the LED.
//
//                 MSP430xG461x
//             -----------------
//        /|\ |              XIN|-
//         |  |                 | 32kHz
//         ---|RST          XOUT|-
//            |                 |
//            |                 |
//            |                 |
//            |             P2.2|--> LED1
//            |                 |
//            |                 |
//            |                 |
//
//  @A. Milenkovic, milenkovic@computer.org
//  Max Avual, ma0004@uah.edu
//**************************************************************************
#include <msp430xG46x.h>


void main(void)
{
 
  WDTCTL = WDT_ADLY_1000;           // 1 s interval timer
  P2DIR |= BIT2;                    // Set P2.2 to output direction
  IE1 |= WDTIE;                     // Enable WDT interrupt
  _BIS_SR(LPM0_bits + GIE);         // Enter LPM0 w/ interrupt
}

// Watchdog Timer interrupt service routine
#pragma vector=WDT_VECTOR
__interrupt void watchdog_timer(void)
{
    P2OUT ^= BIT2;			// Toggle P2.2 using exclusive-OR
}
