lazy.elf: sw_serial.S main.c
	msp430-gcc -Os sw_serial.S main.c -o lazy.elf -mmcu=msp430g2231

install: lazy.elf
	mspdebug rf2500 "prog lazy.elf"

clean:
	rm -f *~ *.elf
