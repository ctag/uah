//**************************************************************************
//  Description: Toggle LED1 on P2.2 using software polling. 
//  In this example the WDT is configured in interval timer mode,
//  and it is clocked with fACLK, where fACLK = 32,768 Hz.
//  
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
//**************************************************************************
#include <msp430xG46x.h>

void main(void)
{
  WDTCTL = WDT_ADLY_1000;           // 1 s interval timer
  P2DIR |= BIT2;                    // Set P2.2 to output direction
  // use software polling
  for (;;) {
    if ((IFG1 & WDTIFG) == 1) {
         P2OUT ^= BIT2;
         IFG1 &= ~WDTIFG;  // clear bit WDTIFG in IFG1
    }
  }
}
