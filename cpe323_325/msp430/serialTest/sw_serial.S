;------------------------------------------------------------------------
; File: sw_serial.S - msp430-gcc software only async serial routines
;
;    Copyright (C) 2011 Kevin Timmerman
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;
; Desc: blocking versions of putchar(), getchar(), and puts() that
;       use cycle counting for accurate sampling and sending. Features
;       very small code size, allows use of any pin, and doesn't interfere
;       with the use of timers.
;
; Change Log:
;    2012-Jan-04 rick@kimballsoftware.com
;                Changes for gcc, renamed function names to
;                allow gcc printf() to work, conditional defines to allow
;                for smaller code, disabled puts() by default so not to
;                conflict with libc version. renamed jump labels to
;                reduce symbol table pollution.
;
;    2011-Oct-23 rick@kimballsoftware.com
;                Initial port to msp430-gcc
;
;    2012-Apr-28 rockets4kids@gmail.com
;                rolled in include file
;                fixed I/O ops to byte (.<img src='http://forum.43oh.com/public/style_emoticons/<#EMO_DIR#>/cool.png' class='bbc_emoticon' alt='B)' /> mode
;
; See Also:
;   Detailed information about original code here:
;   http://www.43oh.com/forum/viewtopic.php?f=10&t=1727
;
;------------------------------------------------------------------------
; TODO: Add optional sleep mode in getchar() which will disable MCU until
;       incoming pin edge detect triggers interrupt.
; TODO: Allow for mulitple serial ports
;------------------------------------------------------------------------

#include <msp430.h>

//------------------------------------------------------------------------------
// define PC,SP,SR as gcc only uses the register names
//
#define PC r0                   
#define SP r1
#define SR r2

//------------------------------------------------------------------------------
// define argument registers
//  C function arguments are passed in R15-R12
//
// Note: these registers can be used without preservation
//
#define ARG1 R15
#define ARG2 R14
#define ARG3 R13
#define ARG4 R12

        
#define ENABLE_GETCHAR              /* enable getchar() */
#define ENABLE_PUTCHAR              /* enable putchar() */
#undef  ENABLE_PUTS                 /* disable puts() as it isn't ISO conforming */
#define ENABLE_AUTO_GIE             /* call __dint() .. __eint() on getchar() putchar() */

        .file "sw_serial.S"

;------------------------------------------------------------------------
; Unitialized SRAM local variables
;------------------------------------------------------------------------
        .lcomm  rx_bit_mask, 2      ; Serial in pin mask
        .lcomm  tx_bit_mask, 2      ; Serial out pin mask
        .lcomm  bit_dur, 2          ; Bit duration in cycles
        .lcomm  half_dur, 2         ; Half bit duration in cycles

;------------------------------------------------------------------------
; Exposed Function Symbols
;------------------------------------------------------------------------
        .text                       ; use the "text" section for all code below
        .global init_serial         ; void init_serial(unsigned out_mask, unsigned in_mask, unsigned bit_duration);
        .global init_serial1        ; void init_serial(_serial_ios *ios);
#ifdef ENABLE_GETCHAR
        .global getchar             ; int getchar(void);
#endif
#ifdef ENABLE_PUTCHAR
        .global putchar             ; int putchar(uint8_t c);
#endif
#ifdef ENABLE_PUTS
        .global puts                ; int puts(const char *s); NOTE: no appended newline
#endif

;------------------------------------------------------------------------
; Serial Function Implementations
;------------------------------------------------------------------------

        .p2align 1,0                ; align on a word boundary
;--------------------------------------------------------------------------------
; void init_serial(int txPinMask, int rxPinMask, int bitDuration)
;--------------------------------------------------------------------------------
        .type init_serial,@function
init_serial:                        ; Setup serial I/O bitmasks and bit duration (minimum of 32)
        mov     ARG1, &tx_bit_mask  ; Save serial output bitmask
        mov     ARG2, &rx_bit_mask  ; Save serial input bitmask
        bis.b   ARG1, &P1DIR        ; set output pin
        bis.b   ARG1, &P1OUT
        bic.b   ARG2, &P1DIR        ; clear input pin
        bis     ARG2, ARG1
#ifdef __MSP430FR5739__
        bic.b   ARG1, &P1SEL0       ; force output pin to digial I/O no pullups
        bic.b   ARG1, &P1SEL1       ; force output pin to digial I/O no pullups
#else
        bic.b   ARG1, &P1SEL        ; force output pin to digial I/O no pullups
#endif
        mov     ARG3, ARG1          ; Compute bit duration
        sub     #16, ARG3           ; Adjust count for loop overhead
        rla     ARG3                ; Multiply by 2 because NOP is two bytes
        mov     ARG3, &bit_dur      ; Save bit duration
        sub     #32, ARG1           ; Adjust count for loop overhead
        mov     ARG1, &half_dur     ; Save half bit duration
        ret                         ; ready to rx/tx
.Lfe1:
        .size init_serial,.Lfe1-init_serial


#ifdef ENABLE_GETCHAR
;--------------------------------------------------------------------------------
; int getchar(void) - read one character (blocking)
;--------------------------------------------------------------------------------
        .p2align 1,0                ; align on a word boundary
        .type getchar,@function
getchar:
        bic     #GIE, SR            ; disable global interrupts
        mov     &bit_dur, R14       ; Bit duration
        mov     &rx_bit_mask, R13   ; Input bitmask
        mov     #0x01FF, ARG1       ; 9 bits - 8 data + stop

.rx_start:                          ; Wait for start bit
        mov.b   &P1IN, R12          ; Get serial input
        and     R13, R12            ; Mask and test bit
        jc      .rx_start           ; Wait for low...
        mov     &half_dur, R13      ; Wait for 1/2 bit time

.rx_delay:
        nop                         ; Bit delay
        sub     #8, R13
        jc      .rx_delay
        subc    R13, PC             ; 0 to 3 cycle delay
        nop                         ; 3
        nop                         ; 2
        nop                         ; 1

        mov.b   &P1IN, R12          ; Get serial input
        and     &rx_bit_mask, R12
        rrc     ARG1                ; Shift in a bit

        mov     R14, R13            ; Setup bit timer
        jc      .rx_delay           ; Next bit...

        rla     ARG1                ; Move stop bit to carry
        swpb    ARG1                ; Move rx byte to lower byte, start bit in msb
        bis     #GIE, SR            ; enable global interrupts
        ret                         ; Return with rx char and start bit in R15, stop bit in carry
.Lfe3:
        .size getchar,.Lfe3-getchar
#endif


#ifdef ENABLE_PUTCHAR
;--------------------------------------------------------------------------------
; int putchar(uint8_t c) - writes the character c to serial out
;--------------------------------------------------------------------------------
        .p2align 1,0                ; align on a word boundary
        .type putchar,@function
putchar:                                ; Char to tx in R15, R12, R13, R14, R15 trashed
        bic     #GIE, SR            ; disable global interrupts
        mov     &tx_bit_mask, R12       ; Serial output bitmask
        mov     &bit_dur, R14       ; Bit duration
        bis     #0x0300, ARG1       ; Add Stop bit(s) to tx char
        jmp     .bit_low            ; Send start bit...

.tx_bit:
        mov     R14, R13            ; Get bit duration
.tx_delay:
        nop                         ; 4 cycle loop
        sub     #8, R13
        jc      .tx_delay
        subc    R13, PC             ; 0 to 3 cycle delay
        nop                         ; 3
        nop                         ; 2
        nop                         ; 1
        rra     ARG1                ; Get bit to tx, test for zero
        jc      .bit_high           ; If high...
.bit_low:
        bic.b   R12, &P1OUT        ; Send zero bit
        jmp     .tx_bit             ; Next bit...
.bit_high:
        bis.b   R12, &P1OUT        ; Send one bit
        jnz     .tx_bit             ; If tx data is not zero, then there are more bits to send...

        bis     #GIE, SR            ; enable global interrupts
        ret                         ; Return when all bits sent
.Lfe2:
        .size putchar,.Lfe2-putchar
#endif


#ifdef ENABLE_PUTS
;--------------------------------------------------------------------------------
; int puts(const char *s) - writes the string s to serial out.
;--------------------------------------------------------------------------------
        .p2align 1,0                ; align on a word boundary
        .type puts,@function
puts:
        push    R11                 ; TX string using putchar
        mov     ARG1, R11           ; String pointer in R15, copy to R11 (temp reg)
.putsloop:
        mov.b   @R11+, ARG1         ; Get a byte, inc pointer
        tst.b   ARG1                ; Test if end of string
        jz      .putsx              ; Yes, exit...
        call    #putchar            ; Call putchar
        jmp     .putsloop
.putsx:
        pop     R11                 ; restore original R11
        ret                         ;
.Lfe4:
        .size puts,.Lfe4-puts
#endif
