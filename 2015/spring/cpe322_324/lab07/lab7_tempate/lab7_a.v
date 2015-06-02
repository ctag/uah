// lab7 Template
// Sine Wave Generation using Pulse Density Modulation

`timescale 1ns/1ps


module lab7_a (input clk,  input [11:0] freq,  input [7:0] vol, output reg d_bit);


   reg en;
	reg signed [15:0] wave_out;

   // 16 bit signed integer 50 point
	// lookup table for sin function	
   reg signed [15:0] sin_table[0:49];
	initial
	   begin:sin_table_init
      // 16 bit integer 50 point sine function
	   // lookup table			
      sin_table[0] = 16'd0;
      sin_table[1] = 16'd1026;
      sin_table[2] = 16'd2037;
      sin_table[3] = 16'd3015;
      sin_table[4] = 16'd3946;
      sin_table[5] = 16'd4815;
      sin_table[6] = 16'd5607;
      sin_table[7] = 16'd6312;
      sin_table[8] = 16'd6916;
      sin_table[9] = 16'd7412;
      sin_table[10] = 16'd7791;
      sin_table[11] = 16'd8046;
      sin_table[12] = 16'd8175;
      sin_table[13] = 16'd8175;
      sin_table[14] = 16'd8046;
      sin_table[15] = 16'd7791;
      sin_table[16] = 16'd7412;
      sin_table[17] = 16'd6916;
      sin_table[18] = 16'd6312;
      sin_table[19] = 16'd5607;
      sin_table[20] = 16'd4815;
      sin_table[21] = 16'd3946;
      sin_table[22] = 16'd3015;
      sin_table[23] = 16'd2037;
      sin_table[24] = 16'd1026;
      sin_table[25] = 16'd0;
      sin_table[26] = -16'd1026;
      sin_table[27] = -16'd2037;
      sin_table[28] = -16'd3015;
      sin_table[29] = -16'd3946;
      sin_table[30] = -16'd4815;
      sin_table[31] = -16'd5607;
      sin_table[32] = -16'd6312;
      sin_table[33] = -16'd6916;
      sin_table[34] = -16'd7412;
      sin_table[35] = -16'd7791;
      sin_table[36] = -16'd8046;
      sin_table[37] = -16'd8175;
      sin_table[38] = -16'd8175;
      sin_table[39] = -16'd8046;
      sin_table[40] = -16'd7791;
      sin_table[41] = -16'd7412;
      sin_table[42] = -16'd6916;
      sin_table[43] = -16'd6312;
      sin_table[44] = -16'd5607;
      sin_table[45] = -16'd4815;
      sin_table[46] = -16'd3946;
      sin_table[47] = -16'd3015;
      sin_table[48] = -16'd2037;
      sin_table[49] = -16'd1026;

		end
		
   always @(posedge clk)
      begin:Clock_en
		   // declaring local variables to
			// named section clock_en
	      reg [19:0] count;
			reg [19:0] base_count;
			if (freq) 
			   begin
 			   base_count = 20'd1000000/freq;
			   if (count)
				   begin
			      count = count - 20'd1;
               en=1'b0;
					end
			   else
			      begin
				   en = 1'b1;
			      count = base_count;	
				   end
				end
		end
		
   always @(posedge clk)
	   begin:Waveform_Gen
         // declaring local variable to
			// named section Waveform_Gen			
		   reg[5:0] index;
			
			if (en)
		      begin	
			   if (index>=6'd49) index = 6'd0;
			   else index = index + 6'd1;
            wave_out = sin_table[index];
				end
	   end			
				
   always @ (posedge clk)
      begin:DtoA_convert
		   // declaring local variable to
			// named section DtoA_convert
         reg signed [31:0] ge; // error term	
			
	      pdm(d_bit,wave_out,{1'b0,vol,7'd0},ge);
		end

	        
   // Pulse Density Modulation Task
   task pdm(output d_out, input signed [15:0] x, input signed [15:0] scale, 
	   inout signed [31:0] ge);
		
      // fixed point encoding of 1.0... assuming a signed 3 bit
      // mantisa and a 29 bit fraction	
	   `define ONE 32'h20000000
		
      // 32 bit holder of x * scale data
      reg signed [31:0] x_total; 
      reg ret_val;

	   begin

	   x_total = x*scale*2; // scaling value
		
		if (x_total >= ge)
		   begin
		   ret_val = 1;
		   ge = ge + (`ONE - x_total);
		   end
		else
	      begin
		   ret_val = 0;
		   ge = ge - (`ONE + x_total); 
		   end	
	   d_out = ret_val;
		end
   endtask
	
endmodule	