//-keypad_scanner-Module-----------------------------------------------
// Top-Level Keypad Scanner Module whose structural components
// labeled C0 through C3 were developed in Laboratory 3.
// These components were placed in a single module that could
// be placed in an Intellectual Property, IP library and used
// in other designs such as the Serial Interface Design being
// developed in Laboratory 4.

// Keypad Assumptions:
//    pull-up resistors are used.
//    DE-2 wiring conforms to that specified in Laboratory 3

// Design Fuction: to perform debounced scanning of the 16-key
// keypad, producing a valid code that corresponds to Table 1
// of the Laboratory 3 Assignment whenever a single key is
// pressed and to produce an active low signal that indicates
// when this event has occurred and when the key output is
// valid.

// Inputs
//   clk: main system clock -- 27 Mhz
//   col: 4-bit inputs from the keypad
// Outputs
//   row: 4-bit outputs to drive the keypad
//   key_valid_: active low signal that indicates a key
//               is pressed and the key code is valid
//  key_code: 4-bit key code that uniquely identifies
//            the key that is pressed in a manner
//            that conforms to Table 1 of Laboratory 3.
module keypad_scanner(clk,col,key_valid_,key_code,row);
   input  clk;
   input  [3:0] col;
   output [3:0] row;
   output key_valid_;
   output [3:0] key_code;

   // internal wires and bus
   wire n0,n1,n2;
   wire [3:0] n3;

   clock_gen C0(.clk_in(clk),.scan_en(key_valid_),.scan_clk(n0),
      .debounce_clk(n2));

   key_scan C1(.clk_in(n0),.col(col),.row(row),.key_out(n1),
      .key_bd_code(n3));

   debounce C2(.sig_in(n1),.clk(n2),.sig_out(key_valid_));

   code_cnv C3(.O(key_code),.I(n3));
endmodule

//-clock_gen Module----------------------------------------------------
// This module generates the scan and debounce clocks pulses
// that are derived from the 27 Mhz Input clock on the DE-2
// board using clock division methods
module clock_gen(clk_in,scan_en,scan_clk,debounce_clk);
   input clk_in,scan_en;
        output scan_clk,debounce_clk;
        reg [15:0] count;

   assign scan_clk = (scan_en) ? count[15]: scan_clk;
        assign debounce_clk = count[11];

        always @ (posedge clk_in)
      begin
                count <= count + 1;
      end
endmodule

//-key_scan Module-----------------------------------------------------
// This submodule is driven by an input clock of the
// appropriate speed and drives the 4 rows of the 16
// button scanning keypad and reads from the
// 4 columns. It does not perform any debouncing on
// the key_out output.
module key_scan(clk_in,col,row,key_out,key_bd_code);
   input clk_in;
   input  [3:0] col;
   output [3:0] row;
   output key_out;
   output [3:0] key_bd_code;

   decoder_2to4_ C0(.data(key_bd_code[1:0]),.out(row));

   mux_4_1 C1(.data(col),.sel(key_bd_code[3:2]),
      .out(key_out));

   binary_counter_4 C2(.clk(clk_in),.count(key_bd_code));

endmodule

//-decoder_2to4_ Module-----------------------------------------------
// 2-to-4 active low output decoder
// with no enable input
// non-structural model
module decoder_2to4_(out,data);
   input [1:0] data;
   output [3:0] out;

   assign out[0] = !(data==0);
   assign out[1] = !(data==1);
   assign out[2] = !(data==2);
   assign out[3] = !(data==3);
   /*
   Same As
      assign out[0] = ~(~data[0] & ~data[1]);
      assign out[1] = ~(data[0]  & ~data[1]);
      assign out[2] = ~(~data[0] & data[1]);
      assign out[3] = ~(data[0]  & data[1]);
   */
endmodule

//- mux_4_1 Module----------------------------------------------------
// Simple 4-to-1 mux with
// no enable moduled
// behaviorally
module mux_4_1(out,sel,data);
   output reg out;
   input [1:0] sel;
        input [3:0] data;

   always @ (sel or data)
      out = data[sel];
endmodule

//- binary_counter_4 Module-------------------------------------------
// Model of a simple -- free running 4-bit
// binary counter with no reset, present,
// or load -- modeled behaviorally
module binary_counter_4 (count,clk);
   input clk;
   output reg [3:0] count;

   always @ (posedge clk)
      count = count + 1;
endmodule


//- debounce Module---------------------------------------------------
// Structural Model of a Debounce Circuit
// Implemented in Laboratory 3.
// sig_in is the noisy sig_pastnal input
// clk is the reference clock set at
//    a rate that is fast enough to catch
//    multiple triggerings of the switch
//    bounce but slow enough that when
//    switch is stable at its new logic
//    level for 8 clock periods final
//    value is allowed to transition.
// sig_out is the clean/debounced
//    signal
module debounce(sig_in,clk,sig_out);
   input sig_in;
   input wire   clk;
   output wire sig_out;

   wire [7:0] sig_past;
   wire n0,n1;

   shift_reg_8 C0(.ser_in(sig_in),.clk(clk),.out(sig_past));

   jk_ff FF0(.j(n0),.clk(clk),.k(n1),.q(sig_out));

   and g0 (n0,sig_past[7],sig_past[6],sig_past[5],sig_past[4],
              sig_past[3],sig_past[2],sig_past[1],sig_past[0]);

   nor g1 (n1,sig_past[7],sig_past[6],sig_past[5],sig_past[4],
              sig_past[3],sig_past[2],sig_past[1],sig_past[0]);

endmodule

//- shift_reg_8 Module-----------------------------------------------
// simple 8-bit shift register
// with output load, enable, or
// clear -- modeled behaviorally
module shift_reg_8(out,ser_in,clk);
   output reg [7:0] out;
   input ser_in,clk;
   always @ (posedge clk)
      begin
         out[7] <= out[6];
         out[6] <= out[5];
         out[5] <= out[4];
         out[4] <= out[3];
         out[3] <= out[2];
         out[2] <= out[1];
         out[1] <= out[0];
         out[0] <= ser_in;
      end
endmodule

//- jk_ff Module------------------------------------------------------
// Simple JK Flip-flop
// modeled behaviorally
module jk_ff(q,j,clk,k);
   input clk,j,k;
   output reg q;

   always @ (posedge clk)
      if (!j && !k)
         q = q; // keep same state
      else if (j && !k)
         q=1;  // set ff
      else if (k && !j)
         q=0; // reset ff
      else if (j && k)
         q=~q; // toggle ff
endmodule

//- code_cnv Module---------------------------------------------------
// simple 4-bit to 4-bit code
// coverter modeled behaviorally
module code_cnv(O,I);
   input [3:0] I;
   output reg [3:0] O;
   always @ (I)
      case (I)
      //input        output
      //value        value
         0     :    O <= 1;
         1     :    O <= 2;
         2     :    O <= 3;
         3     :    O <= 10;
         4     :    O <= 4;
         5     :    O <= 5;
         6     :    O <= 6;
         7     :    O <= 11;
         8     :    O <= 7;
         9     :    O <= 8;
         10    :    O <= 9;
         11    :    O <= 12;
         12    :    O <= 14;
         13    :    O <= 0;
         14    :    O <= 15;
         15    :    O <= 13;
      default  :    O <= 7'bx;
   endcase
endmodule

