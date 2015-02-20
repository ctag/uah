
//- lab5 Module----------------------------------------
// Top Level lab5 module 
// This is the top-level module for the Asynchronous Serial Communication
// Project. When completed the overall design will allow for bidirectional
// communication to occur across the RS-232C serial interface between the 
// computer and the Altera DE2-115 trainer. It is assumed that the global
// clock input of 50 Mhz will be used allowing for a baud rate of 9600 bps
// with no parity and one stop bit. To accomplish this a clock_en IP module
// has been provided. It creates two pulse trains at the base 9600 bps 
// baud rate and at 16 times that rate where the pulse width is one cycle
// of the base baud rate (1/50 Mhz). The base pulse train drives the
// DE-2 to computer uasend sender module and the pulse train that is 16
// times that rate is sent to the uarec receiver module. 
//
// For data transfer from the DE-2 to the computer the overall design 
// incorporates a keypad_scanner module that is composed of modules
// developed previously in Laboratory 4. It produces a unique 4-bit
// code that identifies which key is pressed an active low key_valid_ 
// signal that indicates when the key has been pressed. 
// The 4-bit code produced by the keypad_scanner module must be converted
// into 8-bit ASCII code (see http://www.asciitable.com for details)
// to map the 0-9, A-D, and the * and # keys to the appropriate ASCII 
// character values. This module is to be developed by the student. 
// The key_valid output of the keypad module is at a Logic 0 for the
// entire duration of the key stroke, the major serial module is to
// be designed so that a one cycle pulse activiates its acquisition 
// and serial sending process so a one-shot IP core module is also present
// in the design.
// The uasend sender module contains a simple shift register with
// load, enable, and shift inputs. It is the students resposibility to 
// implement and model behaviorally a valid finite state machine 
// to enable to proper control of this shift register to create a valid
// asynchronous serial pattern that conforms to the standard.  A complete
// STG has been provided to be implemented  by the behaviorally and
// placed in the send_control_logic submodule of the uasend module.  
// The uarec module contains a specialized timer that upon reset will
// count to 16 enabled clock cycles inidicating when the count is 1/2
// complete and when the full 16 enabled clock cycles have transpired.
// It also contains a shift register that is connected to the serial
// input line and is controlled through an enable input. In this lab
// students are to develop the FSM control logic that is to reside in
// the rec_control_logic module that is a submodule to the uasend module. 
// The output of the uarec module drives the lcd module. This IP core
// is driven by the uarec module allowing the user to view the character
// that it receives using the DE-2's LCD. It does this by  outputing 
// eight bits received which is assumed to be ASCII character code
// tothe next position of the two-row 32 character LCD. The module is
// responsible for producing the necessary protocol in response to a 
// one cycle positive edge enabling pulse. This is one of the IP 
// modules, written in Verilog, that is supplied with the assignment.
// Signals:
//    clocking signal
//    CLOCK_50   Input  Main global 50 Mhz Clock
//
//    serial interface signals
//    UART_RXC   Input   Serial Port Input
//    UART_TXD   Output  Serial Port Output
//
//    keypad interface signals
//      COL[3:0] Input   Scanning Keypad Column Inputs
//      ROW[3:0] Output  Scanning Keypad Row Outputs
//
//    seven segment LEDs (DE-2)
//       HEX0[6:0] Output Rightmost Seven Segment LED
//       HEX1[6:0] Output Seven Segment LED
//       HEX2[6:0] Output Seven Segment LED
//       HEX3[6:0] Output Seven Segment LED
//       HEX4[6:0] Output Seven Segment LED
//       HEX5[6:0] Output Seven Segment LED
//       HEX6[6:0] Output Seven Segment LED
//       HEX7[6:0] Output Leftmost Seven Segment LED
//
//    LCD Interface Signals
//       LCD_RS        Output  LCD Reset Signal
//       LCD_RW        Output  LCD Read/Write Signal
//       LCD_EN        Output  LCD Enable Signal
//       LCD_ON        Output  LCD Power On Signal
//       LCD_BLON      Output  LCD Blink On Signal
//       LCD_DATA[7:0] Output  LCD Data bus 
//                     [note this is an output only to this design
//                      but in general is bidirectional]
//
 module lab5(input CLOCK_50,UART_RXD, output UART_TXD,
    input [3:0] COL, output [3:0] ROW,
         output LCD_RS,LCD_RW,LCD_EN,LCD_ON,LCD_BLON,
         output [7:0] LCD_DATA,
	 output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);

    wire n0,n1,n2,n3,n4;
    wire [3:0] b0;
    wire [7:0] b1,b2;

    keypad_scanner  C0(.clk(CLOCK_50),.col(COL),.key_valid_(n0),
       .key_code(b0),.row(ROW));

    clock_en        C1(.clk(CLOCK_50),.en_out16(n3),.en_out(n1));

    one_shot        C2(.clk(CLOCK_50),.i_(n0),.o(n2));

    bin_to_ascii    C3(.I(b0),.O(b1));

    uasend          C4(.en(n1),.clk(CLOCK_50),.go(n2),.data_in(b1),
                        .serial_out(UART_TXD));

    hex_seven_shift C5(.shift(n0),.i(b0),.hex0(HEX0),.hex1(HEX1),
                       .hex2(HEX2), .hex3(HEX3),.hex4(HEX4),
                       .hex5(HEX5),.hex6(HEX6),.hex7(HEX7));

    uarec           C6(.ser_in(UART_RXD),.clk(CLOCK_50),.en(n3),
                       .en_out(n4),.dout(b2));

    lcd             C7(.clk(CLOCK_50),.ds(n4),.ascii_in(b2),.rs(LCD_RS),
                       .rw(LCD_RW), .en(LCD_EN),.lcdon(LCD_ON),
                       .lcdblon(LCD_BLON),.data_out(LCD_DATA));

 endmodule
