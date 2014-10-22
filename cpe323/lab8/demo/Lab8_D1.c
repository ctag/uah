//******************************************************************************
// MSP430xG46x Demo - USCI_A0, 115200 UART Echo ISR, DCO SMCLK
//
// Description: Echo a received character, RX ISR used. Normal mode is LPM0.
// USCI_A0 RX interrupt triggers TX Echo. Toggle LED4 with every received
// character 
//
// Baud rate divider with 1048576hz = 1048576/115200 = ~9.1 (009h|01h)
// ACLK = LFXT1 = 32768Hz, MCLK = SMCLK = default DCO = 32 x ACLK = 1048576Hz
// //* An external watch crystal between XIN & XOUT is required for ACLK *//
//
//      MSP430xG461x
//     -----------------
// /|\ |            XIN|-
//  |  |               | 32kHz
//  |--|RST        XOUT|-
//     |               |
//     |   P2.4/UCA0TXD|------------>
//     |               | 115200 - 8N1
//     |   P2.5/UCA0RXD|<------------
//
// A. Milenkovic, edited by Scott Marconnet
//****************************************************************************** 
#include <msp430xG46x.h> 
void main(void)
{
  WDTCTL = WDTPW+WDTHOLD;    // Stop WDT
  P5DIR |= BIT1;             // Set P5.1 to be output
  P2SEL |= BIT4 + BIT5;      // P2.4,5 = USCI_A0 RXD/TXD
  UCA0CTL1 |= UCSSEL_2;      // SMCLK
  UCA0BR0 = 0x09;            // 1MHz/115200 (lower byte)
  UCA0BR1 = 0x00;            // 1MHz/115200 (upper byte)
  UCA0MCTL = 0x02;           // Modulation (UCBRS0=0x01)(UCOS16=0)
  UCA0CTL1 &= ~UCSWRST;      // **Initialize USCI state machine**
  IE2 |= UCA0RXIE;           // Enable USCI_A0 RX interrupt
  _BIS_SR(LPM0_bits + GIE);  // Enter LPM0, interrupts enabled
} 
// Echo back RXed character, confirm TX buffer is ready first
#pragma vector=USCIAB0RX_VECTOR
__interrupt void USCIA0RX_ISR (void)
{
  while(!(IFG2&UCA0TXIFG));  // Wait until can transmit
  UCA0TXBUF = UCA0RXBUF;     // TX -> RXed character
  P5OUT^=BIT1;               // Toggle LED4
}
