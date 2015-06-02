#include <msp430.h>
#include "sw_serial.h"
#include "msprintf.h"

void main(void)
{
    int c;

    // Disable watchdog 
    WDTCTL = WDTPW + WDTHOLD;

    // Use 1 MHz DCO factory calibration
    DCOCTL = 0;
    BCSCTL1 = CALBC1_1MHZ;
    DCOCTL = CALDCO_1MHZ;
            
    // Setup the serial port
    // Serial out: P1.1 (BIT1)
    // Serial in:  P1.2 (BIT2)
    // Bit rate:   9600 (CPU freq / bit rate)  
    init_serial (BIT1, BIT2, 1000000 / 9600);
    
    //printf(" printf test ");
    
    // Send a string
    puts ("\r\nRunning...\r\n");
    
    for (;;) {           // Do forever
        c = getchar();     // Get a char
        putchar (c);        // Echo it back
    }
}
