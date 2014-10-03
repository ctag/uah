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

#define SW1 (0x01&P1IN)	// B1 - P1.0 switch SW1 
#define SW2 (0x02&P1IN)	// B2 - P1.1 switch SW2

const int rate = 32767;
volatile int clocker = 1000;
volatile int factor = 1000;
volatile int current = 33;

void main(void)
{
  
  WDTCTL = WDT_ADLY_250;           // 1 s interval timer
  P2DIR |= BIT2;                    // Set P2.2 to output direction
  P2DIR |= BIT1;
  P3DIR |= BIT5;
  //P1DIR |= BIT1;
  
  P3SEL |= BIT5;
  P2SEL |= BIT1;
  
  TB0CCTL4 = OUTMOD_4;
  TB0CCTL0 = OUTMOD_4;
  TB0CTL = TBSSEL_1 + MC_1;
  
  current = (rate / clocker);
  
  TB0CCR0 = current; // 32767
  //we want a 900Hz tone
  // So, 1000Hz is a period of 1/1000.
  // Which is 0.0001 seconds, which is 1 ms, which is 1000 us
  
  _EINT();			// Enable interrupts
	P1IE |= 0x0003;		// P1.0 interrupt enabled
	P1IES |= 0x0003;	// P1.0 hi -> low edge
	P1IFG &= ~0x0003;	// Clear P1.0 IFG
  
  
  TB0CCR4 = TB0CCR0;
  
  //P2OUT &= ~BIT1;
  //P3OUT |= ~BIT5;
  
  IE1 |= WDTIE;                     // Enable WDT interrupt
  __enable_interrupt();
  
  _BIS_SR(LPM0_bits + GIE);         // Enter LPM0 w/ interrupt

  while (1)
  {
    asm("NOP");
  }

}

// Watchdog Timer interrupt service routine
#pragma vector=WDT_VECTOR
__interrupt void watchdog_timer(void)
{
    P2OUT ^= BIT2;			// Toggle P2.2 using exclusive-OR
    //P3OUT ^= BIT5;
    //P1OUT ^= BIT1;
}

/*
 * Port 1 interrupt service
 */
#pragma vector = PORT1_VECTOR // The fuck does pragma mean? or vector for that matter.
__interrupt void Port1_ISR (void)
{
	// Constant delay debounce, arbitrary looper value
  // At SCFQCTL=30, we delay 20 NOP instructions.
  // At SCFQCTL=60, we delay 40 NOP instructions.
  // At SCFQCTL=120, we delay 80 NOP instructions.
  // A linear relationship between clock and delay :)
	int factor = (SCFQCTL / 30);
	int looper = (20 * factor);
	
	for (int c = 0; c < looper; c++)
	{
		asm("NOP");
	}
  
	if (((SW1) == 0) && ((SW2) != 0))
	{
		clocker += factor;
	}
	else if (((SW2) == 0) && ((SW1) != 0))
	{
		clocker -= factor;
	}
	
        current = (rate / clocker);
  
  TB0CCR0 = current; // 32767
        
	P1IFG &= ~BIT1;		// Clear P1.1 IFG
	P1IFG &= ~BIT0;		// Clear P1.0 IFG
}





























