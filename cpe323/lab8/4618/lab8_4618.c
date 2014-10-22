/***********************************************************************
 * Title: Lab 8 - 4618 part
 * Date Due: Oct sometime
 * 
 * Description: Ripped from demo code, because fuck the amount of time
 * we have to actually learn something that's otherwise interesting.
 * I'm sorry, that was passive agressive wasn't it.
 * 
 * 19200 - 8N1
 *
 * By: Christopher 'ctag' Bero <csb0019@uah.edu>
 * Project: https://github.com/ctag/uah
 *
 * This software is licensed under the GPLv3,
 * consult the LICENSE file for more information.
 **********************************************************************/

#include <msp430.h> // The *correct* include statement
#include <stdio.h> // Gross, horribly implemented in msp C

#define SW1 0x01&P1IN	// B1 - P1.0 switch SW1 
#define SW2 0x02&P1IN	// B2 - P1.1 switch SW2

// Use instead of int flags
typedef enum {
	false = 0,
	true = 1
} bool;

bool send_time_flag = false;

// Current time variables
unsigned int min=0; // minutes
unsigned int sec=0; // seconds
unsigned char tsec=0; // 1/10 second
char Time[8]; // string to keep current time 

//Function Declarations 
void SetTime(void); 
void SendTime(void); 


//UART0 Initialization 						  
void UART_Initialize(void) // USART in UART Mode 
{   
	P2SEL |= BIT4+BIT5; // Set UC0TXD and UC0RXD to transmit and receive data   
	UCA0CTL1 |= BIT0; // Software reset   
	UCA0CTL0 = 0; // USCI_A0 control register   
	UCA0CTL1 |= UCSSEL_2; // Clock source SMCLK   
	UCA0BR0=54; // 1048576 Hz / 19200   
	UCA0BR1=0; //   
	UCA0MCTL=0x0A; // Modulation   
	UCA0CTL1 &= ~BIT0; // Undo software reset 
}  

// Sets the real-time clock variables 
void SetTime(void) {   
	tsec++;   
	if(tsec == 10)   
	{     
		tsec = 0;     
		sec++; 
	}
	if (sec == 60)
	{
		sec = 0;
		min++;
	}
} 

// Sends the time to the HyperTerminal 
void SendTime(void) {   
	sprintf(Time, "%02d:%02d:%02d", min, sec, (tsec*10)); // prints time to a string   
	for(int i=0;i<8;i++) // Send character by character   
	{     
		while (!(IFG2 & UCA0TXIFG));
		UCA0TXBUF = Time[i];   
	}   
	while (!(IFG2 & UCA0TXIFG));   
	UCA0TXBUF = 0x0D; // Carriage Return 
} 

void main(void)
{
	//WDTCTL = WDT_ADLY_250;
	WDTCTL = (WDTPW|WDTHOLD);
	
	P2DIR |= 0x06;		// Set P2.1 and P2.2 to output direction (0000_0110) 
	P2OUT = 0x02; 		// Set P2OUT to 0000_0010b (LED2 is ON, LED1 is OFF)
	
	P1IE |= 0x0003;		// P1.0 interrupt enabled
	P1IES |= 0x0003;	// P1.0 hi -> low edge
	P1IFG &= ~0x0003;	// Clear P1.0 IFG
	
	P3DIR |= BIT1; // Set P3.1 output
	//P3OUT &= ~BIT1; // Set low
	P3OUT |= BIT1; // Set high
        
	UART_Initialize(); //Initialize UART   /* Initialize Timer A to measure 1/10 sec */   
	TACTL = TASSEL_2 + MC_1+ ID_3; // Select smclk/8 and up mode   
	TACCR0 = 13107; // 100ms interval   
	TACCTL0 = CCIE; // Capture/compare interrupt enable 
	
	//_EINT();			// Enable interrupts
	__enable_interrupt(); // Same as _EINT()?
	
	//IE1 |= WDTIE;                     // Enable WDT interrupt
	//_BIS_SR(LPM0_bits + GIE);         // Enter LPM0 w/ interrupt

	while (1)
	{
		asm("NOP");
		while ((SW1) == 0)
                {
                  P3OUT |= BIT1; // set high
		P2OUT = BIT2;
                }
                if ((SW1) != 0)
		{
			P3OUT &= ~BIT1;
			P2OUT = BIT1;
		}
	}
}

/*
 * Watchdog Timer interrupt service routine
 */
#pragma vector = WDT_VECTOR
__interrupt void watchdog_timer(void)
{

}

/*
 * Port 1 interrupt service routine
 */
#pragma vector = PORT1_VECTOR
__interrupt void Port1_ISR (void)
{
	// Constant delay debounce
	int factor = (SCFQCTL / 30);
	int looper = (30 * factor);
	for (int c = 0; c < looper; c++)
	{ asm("NOP"); }

	if (((SW1) == 0) && ((SW2) != 0)) // SW1 is pressed
	{
		// Light up LED3
		// Use P3.1 high
		P3OUT |= BIT1; // set high
		P2OUT = BIT2;
	} else if (((SW2) == 0) && ((SW1) != 0)) // SW2 is pressed
	{
		// Do nothing.
	}

	P1IFG &= ~BIT1;		// Clear P1.1 IFG
	P1IFG &= ~BIT0;		// Clear P1.0 IFG
}

// Interrupt for the timer 
#pragma vector=TIMERA0_VECTOR
__interrupt void TIMERA_ISA(void) 
{   
	SetTime(); // Set Clock   
	SendTime();
}



























