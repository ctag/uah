// Single Button Texter -- testbench file -- lab10.v file
// Switch Drive module for testbench (to validate single button
// texter design)
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.

// This is the top-level hardware testbench which is used toto drive
// and test the the single button texter module. It includes the 
// base unit under test, UUT, which is the module which converts 
// single button on/off keying into ASCII text and displays this text
// on the LCD and VGA devices using the Teraasic/Altera  DE-2 board.
// It also includes the sw_driver module which produces an on/off 
// digital signal that adheres to a modified Morse encoding at eight 
// different speeds. The final component module is the sw_mux which 
// allows the user to select between the inputs to the texter module
//  being a push button switch on the DE-2 or the output of the 
// sw_driver module.
//
// DE-2 USER INPUTS:
//   EXT_SW -- main On/off input used to manually enter text on the 
//             single button texter
//   KEY0 -- the down key when in the automated text mode -- pressing
//           it decreases the sending speed of the text.
//   KEY1 -- the up key when in the automated text mode -- pressing
//            it increases the sending speed
//   KEY2 -- mode change button switches textbench from default manual
//           key mode where user enters text by supplying logic low
//           values on the EXT_SW input and the automated text mode 
//           where the sw_driver circuit is used to drive the main 
//           sw input signal of the texter_control submodule within
//           module within the texter design
//   KEY3 -- display and testbench reset button
//
// DE-2 USER OUTPUTS:
//     LEDG0        --lights up when sw is pressed (active low)
//     LEDG1-LEDG7  --backspace (lights up when sw is held for a long
//                    time at logic low indicating a backspace over a
//                    previous character is desired
//     LEDR0-LEDR7  --LEDs that individuall light up to indicate the
//                    relative speed of text that is being sent
//                    by the automated text mode module, sw_driver. 
//                    LEDG0 ON=slowest speed - LEDG7 ON = highest speed
//     HEX1,HEX0    --Seven segment LEDs used to indicate approximate
//                    texting speed in WPM
//     LCD signals  -- text output interface signals to the lcd.v 
//                     i/o module
//     VGA signals  -- text output interface signals to the vga.v
//                     i/o module 
module lab10(input EXT_SW, CLOCK_27, input [3:0] KEY,
   output VGA_BLANK, VGA_CLK, VGA_VS, VGA_HS, LCD_BLON, LCD_ON,
   output LCD_EN, LCD_RW, LCD_RS, VGA_SYNC,
   output [6:0] HEX0, HEX1,
   output [7:0] LCD_DATA, LEDG, LEDR,
   output [9:0] VGA_B, VGA_G, VGA_R);

   // internal wires and busses
   wire n0, n1, n2, n3, n4, n5, n6;
   wire [7:0] b0, b1;

   // switch driver module
   sw_driver C0(.clk(CLOCK_27),.sp_up(KEY[1]),.sp_dwn(KEY[0]),
      .reset(n0),.sw_out(n1),.ledr(LEDR));

   // switch multiplexer module
   sw_mux C1(.i0(EXT_SW),.i1(n1),.sel(KEY[2]),.sw_resetn(n0),
      .sw_out(n5));

   // LCD display module
   lcd C2(.clk(CLOCK_27),.reset(n2),.ds(n3),.back_sp(n4),
      .ascii_in(b0),.rs(LCD_RS),.rw(LCD_RW),.en(LCD_EN),
      .lcdon(LCD_ON),.lcdblon(LCD_BLON),.data_out(LCD_DATA));

   // VGA display module
   vga C3(.clk(CLOCK_27),.reset(n2),.ds(n3),.back_sp(n4),
      .ascii_in(b0),.vga_hs(VGA_HS),.vga_vs(VGA_VS),
      .vga_clk(VGA_CLK),.vga_blank(VGA_BLANK),.vga_syn(VGA_SYNC),
      .vga_b(VGA_B),.vga_g(VGA_G),.vga_r(VGA_R));

   // BCD to Hex modules
   bintohex C4(.i(b1[3:0]),.o(HEX0));
   bintohex C5(.i(b1[7:4]),.o(HEX1));

   // key press LED display
   assign LEDG[0] =  ~n5;

   // backspace LED displays
   assign LEDG[1] = n6;
   assign LEDG[2] = n6;
   assign LEDG[3] = n6;
   assign LEDG[4] = n6;
   assign LEDG[5] = n6;
   assign LEDG[6] = n6;
   assign LEDG[7] = n6;

   // main unit under test -- single button texter
   texter UUT(.reset(KEY[3]),.clk(CLOCK_27),.sw(n5),.bk_space(n4),
      .done(n3),.key_bk_space(n6),.reset_nt(n2),.ascii_out(b0),
      .sp_wpm(b1));

endmodule

