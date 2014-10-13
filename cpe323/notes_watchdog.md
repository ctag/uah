#### Watchdog

##### Features of the watchdog timer:

- Four software-selectable time intervals (see WDTISx)
- Watchdog Mode * \*gasp*\ *
- Interval Mode
- Access to WDT control register is password protected (what the hell?)
- Control of RST/NMI pin function
- Selectable clock source
- Can be stopped to conserve power
- Clock fail-safe feature in WDT+ (plz no)

##### Register Definitions

	Register							Short Form		Address		Initial State
	Watchdog timer control register		WDTCTL			0x0120		0x06900 w/ PUC
	SFR Interrupt Enable Register 1		IE1				0x0000		Reset w/ PUC
	SFR Interrupt Flag Register 1		IFG1			0x0002		Reset w/ PUC

##### Register Overview

	WDTCTL Bits:
	[15]-[8]	[7]			[6]			[5]			[4]			[3]			[2]			[1]			[0]
	[WDTPW]		[WDTHOLD]	[WDTNMIES]	[WDTNMI]	[WDTTMSEL]	[WDTCNTCL]	[WDTSSEL]	[WDTIS1]	[WDTIS0]
				rw-(0)		rw-(0)		rw-(0)		rw-(0)		r0-(w)		rw-(0)		rw-(0)		 rw-(0)

- WDTPW 
	- Watchdog timer password. Always read as 069h. Must be written as 05Ah, or a PUC is generated.
- WDTHOLD 
	- Watchdog timer hold. This bit stops the watchdog timer.
	- WDTHOLD = 1 when the WDT is not in use conserves power.
	- 0 Watchdog timer is not stopped
	- 1 Watchdog timer is stopped
- WDTNMIES
	- Watchdog timer NMI edge select. This bit selects the interrupt edge for the NMI interrupt when WDTNMI = 1. Modifying this bit can trigger an NMI. Modify this bit when WDTNMI = 0 to avoid triggering an accidental NMI.
	- 0 NMI on rising edge
	- 1 NMI on falling edge
- WDTNMI
	- Watchdog timer NMI select. This bit selects the function for the RST/NMI pin.
	- 0 Reset function
	- 1 NMI function
- WDTTMSEL
	- Watchdog timer mode select
	- 0 Watchdog mode
	- 1 Interval timer mode
- WDTCNTCL
	- Watchdog timer counter clear. Setting WDTCNTCL = 1 clears the count value to 0000h. WDTCNTCL is automatically reset.
	- 0 No action
	- 1 WDTCNT = 0000h
- WDTSSEL
	- Watchdog timer clock source select
	- 0 SMCLK (~1 MHz)
	- 1 ACLK (32,768 Hz)
- WDTISx
	- Watchdog timer interval select. These bits select the watchdog timer interval to set the WDTIFG flag and/or generate a PUC.
	- 00 Watchdog clock source / 32768
	- 01 Watchdog clock source / 8192
	- 10 Watchdog clock source / 512
	- 11 Watchdog clock source / 64
					
The operation of watchdog is controlled by the 16-bit register WDTCTL. The register is protected by a password WDTPW=0x5A in the upper byte [15-8]. If an incorrect password is used, a reset will occur.

The lower byte of WDTCTL contains bits which control the operation of the watchdog. These bits are cleared to 0 in a Power-On Reset (POR), but are unaffected in a Power-Up Clear (PUC).

WDTCNTCL will always read a value of 0, but writing 1 to the bit will clear the counter.

	ACLK	(32,768Hz) 	WDTSSEL = 1
	SMCLK	(~1MHz)		WDTSSEL = 0
	
##### Counter

The watchdog counter is a register WDTCNT, and is invisible to the coder. It is set from either SMCLK (default) or ACLK, as defined by the WDTSSEL bit.

The reset output can be selected from bits 6, 9, 13, 15 of the counter (WDTCNT), therefore the period is 64, 512, 8192, or 32,768 (default) times the period of the clock. This is controlled by WDTISx bits in WDTCTL. The intervals are roughly 2, 16, 250, and 1000ms if the watchdog runs from ACLK at 32KHz.

	Counter:
	WDTISx:				11		10		01		00
	Bit of WDTCNT:		6		9		13		15
	Value of WDTCNT:	64		512		8192	32768
	Rough period (ms):	2		16		250		1000

##### Stopping the dog

After every reset, the watchdog is running from the default clock (SMCLK, derived from DCO, ~1MHz) and with the default count value (32,768). So the period is the count value (32,768) times the period of the clock (1x10^-6), which is about 32.8 ms. So the timer must be stopped in under 30ms by setting the WDTHOLD bit.

	WDTCTL = (WDTPW|WDTHOLD);

##### Using the watchdog interrupt

If the watchdog is left running, the counter (WDTCNT) must be cleared before it overflows and resets the system. This is done by setting the WDTCNTCL bit, and is called *feeding the dog*.

If the timer overflows and resets the system, it does so through a PUC, which leaves some register values intact. The timer sets WDTIFG flag on the register IFG1. This is cleared by a POR, but not PUC.

WDT Interrupt Flag - WDTIFG - IFG1.0

WDT Interrupt Enable - WDTIE - IE1.0

##### Assembly Software Examples

	; Periodically clear an active watchdog
	;MOV #WDTPW+WDTCNTCL,&WDTCTL ; THIS IS WRONG. And given by Ti as an example...
	
	; Change watchdog timer interval
	MOV #WDTPW+WDTCNTL+WDTSSEL,&WDTCTL
	
	; Stop the watchdog
	MOV #WDTPW+WDTHOLD,&WDTCTL
	
	; Change WDT to interval timer mode, clock/8192 interval
	MOV #WDTPW+WDTCNTCL+WDTTMSEL+WDTIS0,&WDTCTL





	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	