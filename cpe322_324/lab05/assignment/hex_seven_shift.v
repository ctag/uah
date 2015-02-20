//- hex_seven_shift Module----------------------------------------
//This module inputs a 4-bit binary value converts it to a representative
//7-segment hexadecimal symbol and latches this value in the least
//significant (hex0) location while shifting over the last seven 
//hexadecimal values over one segment location to the left.
// Inputs:
//    shift --  latching signal,
//    i     -   4-bit binary number input
// Outputs:
//   hex0[6:0] -- least significant 7-segment hex value
//   hex1[6:0] -- intermediate 7-segment hex value
//   hex2[6:0] -- intermediate 7-segment hex value
//   hex3[6:0] -- intermediate 7-segment hex value
//   hex4[6:0] -- intermediate 7-segment hex value
//   hex5[6:0] -- intermediate 7-segment hex value
//   hex6[6:0] -- intermediate 7-segment hex value
//   hex7[6:0] -- most significant 7-segment hex value
//    
module hex_seven_shift(input shift, input [3:0] i, 
   output reg [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7);

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
