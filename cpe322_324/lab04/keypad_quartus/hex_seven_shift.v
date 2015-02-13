// Add comments that describe the function and operation of this module's operation in your 
// lab report. 
module hex_seven_shift(shift,i,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7);
   input shift;
   input [3:0] i;
   output reg [6:0] hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7;
	reg [6:0] hexout;

	always @ (i)
	   case (i)
		   0  : hexout <= 7'b1000000;
		   1  : hexout <= 7'b1111001;
		   2  : hexout <= 7'b0100100;
		   3  : hexout <= 7'b0110000;
		   4  : hexout <= 7'b0011001;
		   5  : hexout <= 7'b0010010;
		   6  : hexout <= 7'b0000010;
		   7  : hexout <= 7'b1111000;
         8  : hexout <= 7'b0000000;
		   9  : hexout <= 7'b0011000;
		   10 : hexout <= 7'b0001000;
		   11 : hexout <= 7'b0000011;
		   12 : hexout <= 7'b1000110;
		   13 : hexout <= 7'b0100001;
		   14 : hexout <= 7'b0000110;
		   15 : hexout <= 7'b0001110;
		   default : hexout <= 7'bx;
		endcase
	
   always @ (negedge shift) 
      begin
         hex0 <= hexout;
	      hex1 <= hex0;
	      hex2 <= hex1;
	      hex3 <= hex2;
	      hex4 <= hex3;
	      hex5 <= hex4;
	      hex6 <= hex5;
	      hex7 <= hex6;
      end
		
endmodule

