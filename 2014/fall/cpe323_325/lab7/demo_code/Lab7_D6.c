//*************************************************************************** 
//  Lab 7 demo code 6 - LED toggling using Timer B, and capture/compare modules
//    with interrupts
//  Description - This code sets up TB CC channel 0 and 1.  The timer is put
//    in UP/DOWN mode with ACLK source.  TB0 interrupt is called at value 10000
//    and TB1 is called at value 1000.  This simulates a PWM  control -
//    adjusting the TB1 and TB0 CCR register values adjusts the duty cycle
//    of the PWM signal.  Thus when 1000 is reached, TB1 interrupt is called, 
//    and when 10000 is reached, TB0 interrupt is called, then the count is
//    reversed.
//*************************************************************************** 
#include <msp430xG46x.h> 


void main(void) 
{ 
  WDTCTL = WDTPW +WDTHOLD;      // Stop WDT
  _EINT();                      // Enable interrupts
  P2DIR |= BIT1 + BIT2;         // P2.1 and P2.2 set up as output 
  P2OUT &= ~(BIT1 + BIT2);      // ensure LED1 and LED2 are off
  TB0CCTL0 = CCIE;              // TB0 count triggers interrupt 
  TB0CCR0 = 10000;              // Set TB0 (and maximum) count value
  TB0CCTL1 = CCIE;              // TB1 count triggers interrupt
  TB0CCR1 = 10000;               // Set TB1 count value
  TB0CTL = TBSSEL_1 | MC_3;     // AMCLK is clock source, UP/DOWN mode  
  
  _BIS_SR(LPM3);                // Enter Low Power Mode 3 
}

#pragma vector = TIMERB0_VECTOR
__interrupt void timerISR(void)
{
  P2OUT ^= BIT1;                // Toggle LED2
}

#pragma vector = TIMERB1_VECTOR
__interrupt void timerISR2(void)
{
  P2OUT ^= BIT2;                // Toggle LED1
  TBCCTL1 &= ~CCIFG;            // Clear interrupt flag
}