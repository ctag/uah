/***********************************************************************
 * Title: Final Project - plexKey
 * Date Due: Its done when its done
 * 
 * Description:
	This program is a test-flight of ctag's assistive technology
	keyboard. The 4618 will read in from two joysticks
	and output a character to UART. Future versions may include
	baked-in USB host support from MSP430-F2 series chips.
 *
 * By: Christopher 'ctag' Bero <csb0019@uah.edu>
 * Project: https://github.com/ctag/uah
 *
 * This software is licensed under the GPLv3,
 * consult the LICENSE file for more information.
 **********************************************************************/

/*
 * Include Statements
 */
#include <msp430.h> // The general include statement


/*
 * Global Variables
 */
#define SW1 0x01&P1IN	// B1 - P1.0 switch SW1 
#define SW2 0x02&P1IN	// B2 - P1.1 switch SW2

volatile long unsigned int lsx = 0;
volatile long unsigned int lsy = 0;
volatile long unsigned int rsx = 0;
volatile long unsigned int rsy = 0;

short unsigned int lsx_percent = 0;
short unsigned int lsy_percent = 0;
short unsigned int rsx_percent = 0;
short unsigned int rsy_percent = 0;

char current_char = '\0';

int alpha_index [3][4] = {
	-1, 0, -1,
	1, -1, 2,
	3, -1, 4,
	-1, 5, -1
};

char alphabet[6][6] = {
	'A', 'B', 'C', 'D', 'E', 'F',
	'G', 'H', 'I', 'J', 'K', 'L',
	'M', 'N', 'O', 'P', 'Q', 'R',
	'S', 'T', 'U', 'V', 'W', 'X',
	'Y', 'Z', '0', '1', '2', '3',
	'4', '5', '6', '7', '8', '9',
	};

/*
 * (Somewhat) Constant Delay and Debounce
 */
void Delay_Debounce(void)
{
	// Constant delay debounce
    int factor = (SCFQCTL / 30);
	int looper = (20 * factor);
	for (int c = 0; c < looper; c++)
	{ asm("NOP"); }
}

/*
 * USART in UART Mode 
 */
void UART_Initialize(void) 
{   
	P2SEL |= BIT4+BIT5;	// Set UC0TXD and UC0RXD to transmit and receive data   
	UCA0CTL1 |= BIT0;	// Software reset   
	UCA0CTL0 = 0;		// USCI_A0 control register   
	UCA0CTL1 |= UCSSEL_2; // Clock source SMCLK   
	UCA0BR0=54;			// 1048576 Hz / 19200   
	UCA0BR1=0;
	UCA0MCTL=0x0A;		// Modulation   
	UCA0CTL1 &= ~BIT0;	// Undo software reset 
}  

/*
 * Write a char to the serial buffer
 */
void UART_Write(char c) 
{
	while (!(IFG2 & UCA0TXIFG));
	UCA0TXBUF = c;
} 

void Generate_Section(short unsigned int input, char axis)
{
	if (axis = 'x') {
		if (input < 33) {
			return (0);
		} else if (input >= 33 && input <= 66) {
			return (1);
		} else if (input > 66) {
			return (2);
		}
	} else {
		if (input < 25) {
			return (0);
		} else if (input >= 25 && input < 50) {
			return (1);
		} else if (input >= 50 && input < 75) {
			return (2);
		} else if (input >= 75) {
			return (3);
		}
	}
}

void UART_Send_Char(void)
{
	lsx_percent = (lsx*3/4095*100/3);
	lsy_percent = (lsy*3/4095*100/3);
	rsx_percent = (rsx*3/4095*100/3);
	rsy_percent = (rsy*3/4095*100/3);
	
	int lsx_loc = Generate_Section(lsx_percent, 'x');
	int lsy_loc = Generate_Section(lsy_percent, 'y');
	int rsx_loc = Generate_Section(rsx_percent, 'x');
	int rsy_loc = Generate_Section(rsy_percent, 'y');
	
	if ((alpha_index[lsx_loc][lsy_loc] == -1) || (alpha_index[rsx_loc][rsy_loc] == -1)) {
		return;
	}
	
	int l_index = alpha_index[lsx_loc][lsy_loc];
	int r_index = alpha_index[rsx_loc][rsy_loc];
	
	if (lsx > 50 && rsx > 50)
	{
		UART_Write(alphabet[l_index][r_index]);
	}
}

void main(void)
{
	WDTCTL = (WDTPW|WDTHOLD);
	
	UART_Initialize();
	
	// Setup input pins
	P6DIR &= ~0xF0;	// Configure P6.4,5,6,7 as input pins  
	P6SEL |= 0xF0;	// Configure P6.4,5,6,7 as analogue pins
	
	// Setup Timer_A
	TACCR0 = 3277;				// 3277 / 32768 Hz = 0.1s
	TACTL = TASSEL_1 + MC_1;	// ACLK, up mode  
	//TACCTL0 = CCIE;				// enabled interrupt
	
	// Setup ADC 12
	ADC12CTL0 = ADC12ON + SHT0_8 + MSC;	// configure ADC converter
	ADC12CTL1 = SHP + CONSEQ_1;		// Use sample timer, single sequence
	ADC12MCTL0 = INCH_4;			// ADC channel 0 is A4 pin - Left-Stick X-axis
	ADC12MCTL1 = INCH_5;			// ADC channel 1 is A5 pin - Left-Stick Y-axis
	ADC12MCTL2 = INCH_6;			// ADC channel 2 is A6 pin - Right-Stick X-axis
	ADC12MCTL3 = INCH_7 + EOS;		// ADC channel 3 is A7 pin - Right-Stick Y-axis
	// EOS - End of Sequence for Conversions
	
	ADC12IE |= 0x0008;	// Enable ADC12 Interrupts
	Delay_Debounce();	// Delay for reference start-up
	ADC12CTL0 |= ENC;	// Enable conversions
	
	_EINT();	// Enable interrupts
	
	//_BIS_SR(LPM0_bits + GIE);         // Enter LPM0 w/ interrupt

	while (1)
	{
		
		
	}
}

/*
 * ADC12 ISR
 */
#pragma vector = ADC12_VECTOR
__interrupt void ADC12_ISR(void)
{
  lsx = ADC12MEM0;	// Move results
  lsy = ADC12MEM1;
  rsx = ADC12MEM2;
  rsy = ADC12MEM3; // IFG cleared
  
  //__bic_SR_register_on_exit(LPM0_bits);	// Exit LPM0
}

/*
 * TIMER_A ISR
 */
#pragma vector = TIMERA0_VECTOR
__interrupt void TIMERA_ISR(void)
{
	if (lsx != 0) {
		UART_Send_Char();
	}
	
	lsx = 0;
	lsy = 0;
	rsx = 0;
	rsy = 0;
	
	ADC12CTL0 |= ADC12SC;
	
	//__bic_SR_register_on_exit(LPM0_bits);     // Exit LPM0
}





























