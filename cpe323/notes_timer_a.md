#### Timer_A

##### Two main parts to the hardware

- Timer Block: Based on the counter, a 16-bit register, TAR. TAIFG is raised when the counter returns to 0;
- Capture / Compare Channels: Based on register TACCRn, which all work in the same way except TACCR0.

##### Capture / Compare Channels Can

- Capture an input.
	- Entails recording the 'time' (value of TAR) at which the input changes in TACCRn.
- Compare the current value of TAR with the value stored in TACCRn and update an output when they match.
- Request an interrupt by setting its flag TACCRn CCIFG on either of these events.
- Sample an input at a compare event. Useful for serial comms.

##### General Notes

- The number of Capture / Compare Channels is sometimes appended to the name, as in Timer_A3.
- Channel 0 (TACCR0) is unavailable in Up and Up/Down modes. It has its own interrupt vector w/ higher priority.
- TAR increments on the rising edge.

###### An important distinction with registers

The demo lab code tends to use 'TA0CTL' when it really means 'TACTL'. 
This is most likely because it's possible to have multiple Timer_A's, 
which would make specifying *which* necessary. As it stands, we're only 
using the first Timer_A, and in the background libraries, TA0CTL is simply 
redifined as TACTL, rendering it useless. Please be aware of this while 
going through any MSP code, the registers are one and the same. To help 
alleviate the headache this causes, I will attempt to document with both names 
and then only use my preffered one while coding.

##### Registers

Hint: All of the below registers, for both timers, are reset on POR.

Hint: Cap/Comp is capture & compare.

###### Timer_A / Timer0_A3

	Register				Access		Alt Access		Address
	control					TACTL		TA0CTL			0x0160 (rw)
	counter					TAR			TA0R			0x0170 (rw)
	cap/comp control 0		TACCTL0		TA0CCTL			0x0162 (rw)
	cap/comp compare 0		TACCR0		TA0CCR0			0x0172 (rw)
	cap/comp control 1		TACCTL1		TA0CCTL1		0x0164 (rw)
	cap/comp compare 1		TACCR1		TA0CCR1			0x0174 (rw)
	cap/comp control 2		TACCTL2		TA0CCTL2		0x0166 (rw)
	cap/comp compare 2		TACCR2		TA0CCR2			0x0176 (rw)
	interrupt vector		TAIV		TA0IV			0x012E (r )

###### Timer1_A

	Register				Access		Address
	control					TA1CTL		0x0180 (rw)
	counter					TA1R		0x0190 (rw)
	cap/comp control 0		TA1CCTL0	0x0182 (rw)
	cap/comp compare 0		TA1CCR0		0x0192 (rw)
	cap/comp control 1		TA1CCTL1	0x0184 (rw)
	cap/comp compare 1		TA1CCR1		0x0194 (rw)
	cap/comp control 2		TA1CCTL2	0x0186 (rw)
	cap/comp compare 2		TA1CCR2		0x0196 (rw)
	cap/comp control 3		TA1CCTL3	0x0188 (rw)
	cap/comp compare 3		TA1CCR3		0x0198 (rw)
	cap/comp control 4		TA1CCTL4	0x018A (rw)
	cap/comp compare 4		TA1CCR4		0x019A (rw)
	interrupt vector		TA1IV		0x011E (r )

##### MCx Bits
- Stop (00): Timer is halted. Registers retain their values.
- Continuous (10): Counter runs through its full range from 0x0000 to 0xFFFF.
- Up (01): Counts from 0 up to the value in TACCR0, the capture/compare register for channel 0. Period is TACCR0+1.
- Up/Down (11): Counts from 0 to TACCR0, then down again to 0. Period is 2*TACCR0.
