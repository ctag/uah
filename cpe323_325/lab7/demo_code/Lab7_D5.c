//*************************************************************************** 
// MSP430xG46x Demo - Timer_B, Toggle P2.1/TB0, UP mode, ACLK 
// 
// Description: Toggle P2.1 using hardware TB0 output. 
// Timer_B is configured in UP mode. In this mode, 
// the timer TB counts from 0 up to value stored in TB0CCR0. 
// So the counter period is CCR0*1us.
// The TB0 output signal is configured to toggle every time
// the counter reaches the TB0CCR0.
// TB0 is multiplexed with the P2.1,
// and LED2 is connected to this output. 
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
//            |         P2.1/TB0|--> 32768/ACLK
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
  TB0CTL = TBSSEL_1 + MC_1;  // AMCLK is clock source, UP mode
  TB0CCR0 = 32767;
  _BIS_SR(LPM3_bits + GIE);  //Enter Low Power Mode 3 
}
