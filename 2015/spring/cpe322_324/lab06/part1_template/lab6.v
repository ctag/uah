// CPE 324 Template File for Part 1 of Lab 6
// Mostly Structural Design of Capacitance Tester
// B. Earl Wells
// Note: all modules are in this one file which should
//       be named lab6.v to match the name of the
//       project with the name of the top-level entity. 
//       Modules are to be completed by the student.
//       The design itself is structural at the top level
//       except for the display section which is modelled
//       behaviorally. This was done to illustrate how
//       both techniques can be used in the same module.
//       The component modules themselves can be implemented
//       in any manner that is convenient (i.e. behavioral,
//       dataflow or structural).
module lab6(input SIG,CLOCK_50,output [6:0] HEX3,HEX2,HEX1,HEX0);

   wire en_pulse,cnt_clr,ff_en;

   wire [15:0] cnt_out,ff_out; // 16bit counter out and D ff out

   // need to set the two parameters for this module in order
   // for it to generate the correct pulse rate 
	
	// Bero: Using Verilog 2001 syntax
   count_enabler  #(.buswidth(16),.full_count(1771)) C0(SIG,CLOCK_50,en_pulse);

   d_ff           C1(SIG,CLOCK_50,cnt_clr);

   bcd_counter    C2(cnt_clr,en_pulse,CLOCK_50,cnt_out);

   d_ff_16_en     C3(cnt_out,ff_en,CLOCK_50,ff_out);

   one_shot       C4(SIG,CLOCK_50,ff_en);

   // output display section -- modeled behaviorally
   // to function as shown in Figure 3 of Lab
   always @ (posedge CLOCK_50)
      begin
         bintohex(ff_out[15:12],HEX3); // output most sig 7-seg
         bintohex(ff_out[11:8], HEX2);
         bintohex(ff_out[7:4],  HEX1);
         bintohex(ff_out[3:0],  HEX0); // output least sig 7-seg
      end      

   // binary to 7-seg hexadecimal output task
   task bintohex (input [3:0] bin_num, output [6:0] hex_num);
      case (bin_num)
         0  : hex_num <= 7'b1000000;
         1  : hex_num <= 7'b1111001;
         2  : hex_num <= 7'b0100100;
         3  : hex_num <= 7'b0110000;
         4  : hex_num <= 7'b0011001;
         5  : hex_num <= 7'b0010010;
         6  : hex_num <= 7'b0000010;
         7  : hex_num <= 7'b1111000;
         8  : hex_num <= 7'b0000000;
         9  : hex_num <= 7'b0011000;
         10 : hex_num <= 7'b0001000;
         11 : hex_num <= 7'b0000011;
         12 : hex_num <= 7'b1000110;
         13 : hex_num <= 7'b0100001;
         14 : hex_num <= 7'b0000110;
         15 : hex_num <= 7'b0001110;
    default : hex_num <= 7'bx;
      endcase
   endtask

endmodule

// positive pulse active high one-shot element 
//    when the tr input is high this module will produce a single
//    positive pulse and will not produce another pulse until
//    the tr input is low for at least one cycle
// Inputs:
//   tr  -- active high trigger input
//   clk -- global clock input
// Output:
//   o   -- pulse output
module one_shot (input tr,clk,output o);

   reg state;

   assign o = ~state & tr;
   always @(posedge clk)
      begin
         state = tr;
      end

endmodule

// counter enabling module
// produces a one cycle enabling pulse 1/2 master clock
// cycle initially and 1 master clock cycle thereafter
// when reset is low
// need to set the two parameters when this module is instantiated
// in order for it to generate the correct pulse rate.
module count_enabler(input reset,clk,output reg en_out);
   parameter buswidth=10,full_count=957; // default values (not correct)

   reg [buswidth-1:0] count;

   always @ (posedge clk, posedge reset) 
      if (reset)
         begin 
            count = full_count/2; // half count value
            en_out = 1;
         end
      else
         if (count)
            begin
               count = count - 1;
               en_out = 0;
            end
         else
            begin
               count = full_count; // full count value
               en_out = 1;
            end

endmodule

// Advances the 4 "digit" (16 bit) BCD Counter
// to the next value for each rising edge clock
// cycle when the en input is '1'
module bcd_counter(input clear,en,clk, output reg [15:0] o);
	/*
	reg [15:0] counter = 0;
	reg dig1[3:0];
	reg dig2[3:0];
	reg dig3[3:0];
	reg dig4[3:0];
	*/
	reg doClear = 0;
	reg doCount = 0;
	
   always @(posedge clk)
	begin
			o = o + en;
			if (o[3:0] > 9)
			begin
				o[3:0] = 0;
				o[7:4] = o[7:4] + 1;
			end
			if (o[7:4] > 9)
			begin
				o[7:4] = 0;
				o[11:8] = o[11:8] + 1;
			end
			if (o[11:8] > 9)
			begin
				o[11:8] = 0;
				o[15:12] = o[15:12] + 1;
			end
			if (o[15:12] > 9)
			begin
				o[15:12] = 0;
				//o[7:4] = o[7:4] + 1;
			end
			if (clear)
			begin
				o = 0;
			end
	end

endmodule

// A D Flip-flop
module d_ff(input d,clk, output reg o);

   always @ (posedge clk) 
      o = d;

endmodule

// simple 16 bit wide D-FF with enable
module d_ff_16_en(input [15:0] d, input en,clk, output reg [15:0] o);

   always @ (posedge clk) 
      if (en) 
         o=d;
      else
         o=o;

endmodule


