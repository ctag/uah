//*************************************************************************** 
// MSP430xG46x Demo - Timer_B, Toggle P2.1/TB0, Continuous mode, DCO SMCLK 
// 
// Description: Toggle P2.1 using hardware TB0 output. 
// Timer_B is configured for continuous mode. In this mode, 
// the timer TB counts from 0 up to 0xFFFF (default 2^15). 
// So the counter period is 65536*1us = 65ms.
// The TB0 output signal is configured to toggle every time
// the counter reaches the maximum value, which corresponds to 65ms.
// TB0 is multiplexed with the P2.1,
// and LED2 is luckily connected to this output. 
// Thus the output frequency on P2.1 will be f = SMCLK/(2*65536) ~ 7.63 Hz. 
// Please note that once configured, the Timer_B toggles the LED2 
// automatically (the CPU is in sleep mode).  
// SMCLK = MCLK = TBCLK = default DCO ~1048kHz, ACLK = 32,768 Hz 
// 
//                 MSP430xG461x
//             -----------------
//        /|\ |              XIN|-
//         |  |                 | 32kHz
//         ---|RST          XOUT|-
//            |                 |
//            |                 |
//            |         P2.1/TB0|--> 65536/SMCLK
//            |                 |
// @ A. Milenkovic, milenkovic@computer.org
// March 2012 
//*************************************************************************** 

#include <msp430xG46x.h> 

void main(void) 
{ 
  WDTCTL = WDTPW +WDTHOLD;  // Stop WDT 
  P2DIR |= BIT1;            // P2.1 output 
  P2SEL |= BIT1;            // P2.1 special function (TB0 output)  
  TB0CCTL0 = OUTMOD_4;      // TB0 output is in toggle mode 
  TB0CTL = TBSSEL_2 + MC_2; // SMCLK is clock source, Continuous mode 
  _BIS_SR(LPM0_bits + GIE); //Enter Low Power Mode 0 
}
