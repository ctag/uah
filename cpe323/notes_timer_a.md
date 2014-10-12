### Timer_A

Two main parts to the hardware:

- Timer Block: Based on the counter, a 16-bit register, TAR. TAIFG is raised when the counter returns to 0;
- Capture / Compare Channels: Based on register TACCRn, which all work in the same way except TACCR0.

Capture / Compare Channels Can:

- Capture an input.
	- Entails recording the 'time' (value of TAR) at which the input changes in TACCRn.
- Compare the current value of TAR with the value stored in TACCRn and update an output when they match.
- Request an interrupt by setting its flag TACCRn CCIFG on either of these events.
- Sample an input at a compare event. Useful for serial comms.

General Notes:

- The number of Capture / Compare Channels is sometimes appended to the name, as in Timer_A3.
- Channel 0 (TACCR0) is unavailable in Up and Up/Down modes. It has its own interrupt vector w/ higher priority.
- TAR increments on the rising edge.

MCx Bits:
- Stop (00): Timer is halted. Registers retain their values.
- Continuous (10): Counter runs through its full range from 0x0000 to 0xFFFF.
- Up (01): Counts from 0 up to the value in TACCR0, the capture/compare register for channel 0. Period is TACCR0+1.
- Up/Down (11): Counts from 0 to TACCR0, then down again to 0. Period is 2*TACCR0.
