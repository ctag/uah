/***********************************************************************
 * Title: Lab 7 Assignment
 * Date Due: Oct sometime
 * 
 * Description:
 * Here we will use Timer_B to modulate the output of Port 3.5 (TB4)
 * in order to drive an annoying-as-fuck speaker on the Exp Board!
 * The main idea is that you /must/ run both cap/comp 0 and 4. Cap/comp
 * 0 is used to drive the clock and TBCCR0 sets the max value for most
 * of the MCx settings, such as "UP" mode.
 * In order to make the calculations easier, I'm going to use 'toggle'
 * mode in this program, which means that TBCCR4 *doesn't matter* and
 * we can module the speaker directly with TBCCR0 :D
 * Also, we use watchdog for something, I think...
 *
 * By: Christopher 'ctag' Bero <csb0019@uah.edu>
 * Project: https://github.com/ctag/uah
 *
 * This software is licensed under the GPLv3,
 * consult the LICENSE file for more information.
 **********************************************************************/

#include <msp430.h> // The *correct* include statement

#define SW1 0x01&P1IN	// B1 - P1.0 switch SW1 
#define SW2 0x02&P1IN	// B2 - P1.1 switch SW2

#define LED1 BIT2; // LED1 - P2.2 - 0x04
#define LED2 BIT1; // LED2 - P2.1 - 0x02

// Usage: WDTCTL = WDT_CONFIG;
#define WDT_CONFIG (WDTPW|WDTCNTCL|WDTSSEL) // Set bits to give us 1s watchdog
#define WDT_INTERVAL (WDTPW|WDTCNTCL|WDTTMSEL|WDTSSEL|WDTIS0) // Set bits to have a 1s timer
#define WDT_HALT (WDTPW|WDTHOLD) // Set bits to halt the timer

short unsigned int new_note_flag = 0;

double freq[] = {440.00, 493.88, 523.25, 587.33, 659.25, 698.46, 783.99};
char notes[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G'};

char mysong[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G'};

int index = 0;

int notes_len = 7;
int mysong_len = 7;

char note;

void main(void)
{
	WDTCTL = WDT_INTERVAL;
	IE1 |= BIT0; // BIT0 is WDTIE
	__enable_interrupt();
	
	P3DIR |= BIT5; // Set P3.5 to OUT
	P3SEL |= BIT5; // Setup the special TB4 function of P3.5
	
	/* // Setup Timer_B's TBCTL
	// BITs Mapping for TxCTLx:
	//	[15]	[14]	[13]	[12]	[11]	[10]	[9]		[8]
	//	NA		NA		NA		NA		NA		NA		TASSEL	TASSEL
	//	0		0		0		0		0		0		0		1
	//
	//	[7]		[6]		[5]		[4]		[3]		[2]		[1]		[0]
	//	ID		ID		MC		MC		NA		TACLR	TAIE	TAIFG
	//	0		1		0		1		0		0		0		0
	//
	// Condensed: [0000][0001] [0101][0000]
	//
	// Specifics:
	// TASSELx = 01, ACLK
	// IDx = 01, divide ACLK by 2, ACLK/2 = 16,384
	// MCx = 01, UP mode
	*/
	TBCTL = 0x0150;
	
	/* // Choosing a value for TBCCR0:
	// This is a little tricky, because you can tackle this problem
	// from a multitude of angles, and the one I chose is likely non-standard,
	// but makes much more sense to me.
	// So, TBCCR0 represents the period out of 16,384 which we wish
	// for the speaker to be pulsed each second. A value of 16,384 means
	// the speaker will click once per second. A value of 16 means the
	// speaker will click about 1000 times per second, which is an audible tone!
	//
	// The formula:
	// TBCCR0 = [ACLK = 16384] / [desired freq in Hz]
	//
	// So, for 900Hz, TBCCR0 = [16384] / [900] = 18.2 = 18.
	*/
	TBCCR0 = 19;
	
	/* // Setup Timer_B's TBCCTL4
	// BITs Mapping for TxCTLx:
	//	[15]	[14]	[13]	[12]	[11]	[10]	[9]		[8]
	//	CM		CM		CCIS	CCIS	SCS		CCLD	CCLD	CAP
	//	0		0		0		0		0		0		0		0
	//
	//	[7]		[6]		[5]		[4]		[3]		[2]		[1]		[0]
	//	OUTMOD	OUTMOD	OUTMOD	CCIE	CCI		OUT		COV		CCIFG
	//	1		0		0		0		0		0		0		0
	//
	// Condensed: [0000][0000] [1000][0000]
	//
	// Specifics:
	// OUTx = 100, Toggle mode (on TB4 of course) 
	*/
	TBCCTL4 = 0x0080;
	
	TBCCR4 = 1; // doesn't matter, can be any valid value
	
	while (1)
	{
		while (new_note_flag == 0)
		{
			asm("NOP");
		}
		new_note_flag = 0;
		
		for (int i = 0; i < notes_len; i++)
		{
			if (notes[i] == note)
			{
				TBCCR0 = (16384 / freq[i]);
				break;
			}
		}
		
	}
}

#pragma vector = WDT_VECTOR
__interrupt void blink_watchdog(void)
{
	new_note_flag = 1;
	index ++;
	if (index == mysong_len)
	{
		index = 0;
	}
	note = mysong[index];
}



























