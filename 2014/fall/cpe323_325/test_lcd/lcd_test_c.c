/***********************************************************************
 * An lcd test. Nothing more.
 **********************************************************************/

#include <msp430.h> // The correct include statement
#include <intrinsics.h>
#include <stdint.h>

#define SW1 (0x01&P1IN)	// B1 - P1.0 switch SW1 
#define SW2 (0x02&P1IN)	// B2 - P1.1 switch SW2

#define LCDMEMS 11
uint8_t * const LCDMem = (uint8_t *) &LCDM3;

void InitLCD (void);

void main(void)
{
	WDTCTL = WDTPW|WDTHOLD;
	
	int i, j;
	enum {up, down} direction;
	
	P2OUT = BIT2;
	P2DIR = BIT1|BIT2;
	
	InitLCD();
	
	TACCR0 = 0x1000;
	TACCTL0 = CCIE;
	TACTL = MC_1 | TASSEL_1 | TACLR;
	
	direction = up;
	
	while (1)
	{
		for (i = 0; i < LCDMEMS; ++i) 
		{
                  for (j = 0; j < 8; ++j)
                  {
			__low_power_mode_3();
			if (direction == up) {
				LCDMem[i] = (LCDMem[i] << 1) | BIT0;
				
			}
			else {
				LCDMem[i] = (LCDMem[i] << 1);
			}
                  }
                  __low_power_mode_3();
                  __low_power_mode_3();
		}
		if (direction == up) {
			direction = down;
		} else {
			direction = up;
		}
	}
}

void InitLCD (void)
{
	int i;
	for (i = 0; i < LCDMEMS; ++i)
	{
		LCDMem[i] = 0;
	}
	P5SEL = BIT4 | BIT3 | BIT2;
	LCDAPCTL0 = LCDS4|LCDS8|LCDS12|LCDS16|LCDS20|LCDS24;
	LCDAVCTL0=0;
	LCDACTL = LCDFREQ_128 | LCD4MUX | LCDSON | LCDON;
}

#pragma vector = TIMERA0_VECTOR
__interrupt void TIMERA0_ISR (void)
{
	P2OUT ^= BIT1|BIT2;
	__low_power_mode_off_on_exit();
}



























