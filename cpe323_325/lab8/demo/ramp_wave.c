/* *********************************************************************************
* Description: This program sends 8-bit counter value via a UART channel.
*              It illustrates the use and configuration 
*              of the UAH Serial Application. 
*              Watchdog timer is configured in the interval mode.
*              It generates an interrupt request every 32 ms.
*              The service routine sends a 2-byte message over UART:    
*              8-bit header (0x55) followed by a 8-bit counter value.
*              The counter is incremented every time we enter the service routine.
*              The UAH Serial App should plot a ramp-like signal.
*
* Platform:    TI Experimenter's board with MSP430FG4618/F2013
*
* Files:       ramp_wave.c
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
    //WDTCTL = WDTPW + WDTHOLD; // Stop watchdog timer
    WDTCTL = WDT_MDLY_32; // watchdog timer in interval mode, 32 ms
    //Initialize the UART
    UART_Initialize();   
    IE1 |= WDTIE;
    _BIS_SR(LPM0_bits + GIE);
    /*
    while(1)
    {      
        // since short int is 8bits long, possible values of temp 
        // variable is 0 to 255
        for(temp=0; temp<256;temp++)
        {
            //Send UAH Serial App Header and Data
            UART_putchar(0x55);
            UART_putchar(*value); 
        }      
    }
    */
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
  static char cnt = 0;
  cnt++;
  UART_putchar(0x55);
  UART_putchar(cnt);
}

