/* *********************************************************************************
* Description: This program sends a 7-byte message via a UART channel.
*              It illustrates the use and configuration 
*              of the UAH Serial Application. 
*              Watchdog timer is configured in the interval mode.
*              It generates an interrupt request every 32 ms that wakes up CPU.
*              The main loop of the program sends a 7-byte message over UART:    
*              8-bit header (0x55), followed by a 16-bit counter value,
*              and a 4-byte floating point value (constant set to 32768.0).
*              The counter is incremented every time the CPU is waken up.
*              The UAH Serial App should plot two signals, a ramp-like counter
*              and a constant set to 32,768. 
*
* Platform:    TI Experimenter's board with MSP430FG4618/F2013
*
* Files:       ramp_wave_floatconst.c
*              
* Setup:       Connect RS-232 cable from TI Experimenter's board with 
*              MSP430FG4618/F2013 to a workstation that plots the.
*              
*
* Author:      Aleksandar Milenkovic
* Contact:     milenkovic@computer.org
* Date:        June 2013
************************************************************************************/

#include <msp430xG46x.h>  

// UART Initializaion
void UART_Initialize(void);

//send char function
void UART_putchar(char c);

void main(void)
{
    unsigned int cnt = 0;
    const float hconst = 32768.0;
    char * p_cnt = (char *) & cnt;
    char * p_hconst = (char *) & hconst;
    
    WDTCTL = WDT_MDLY_32; // watchdog timer in interval mode, 32 ms
    //Initialize the UART
    UART_Initialize();   
    IE1 |= WDTIE;
    while (1) { 
      _BIS_SR(LPM0_bits + GIE);
      cnt++;
      UART_putchar(0x55);
      //Send the integer value first, byte by byte
      UART_putchar(p_cnt[0]); 
      UART_putchar(p_cnt[1]);       
      //Send the float value, byte by byte
      UART_putchar(p_hconst[0]);       
      UART_putchar(p_hconst[1]);
      UART_putchar(p_hconst[2]);       
      UART_putchar(p_hconst[3]);
    }
}

/* 38,400 bits/sec, 1 stop bit, no parity */
void UART_Initialize(void)
{
      P2SEL |= BIT4+BIT5; // Set UC0TXD and UC0RXD to transmit and receive data
      UCA0CTL1 |= BIT0;   // software reset
      UCA0CTL0 = 0;       // USCI_A0 control register
      UCA0CTL1 |= UCSSEL_2; // clock source SMCLK
      UCA0BR0=27;       // 1 MHz 38400
      UCA0BR1=0;        // 1 MHz 38400
      UCA0MCTL=0x94;    // Modulation
      UCA0CTL1 &= ~BIT0; // software resetIE2 |=UCA0RXIE; 
}

void UART_putchar(char c) 
{
      // wait for other character to transmit
      while (!(IFG2 & UCA0TXIFG));
      UCA0TXBUF = c;
}

// Watchdog Timer, interval mode, interrupt service routine
#pragma vector=WDT_VECTOR
__interrupt void watchdog_timer(void)
{
    _BIC_SR_IRQ(LPM0_bits); // Clear LPM0 bits from 0(SR) 
}


