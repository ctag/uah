// 4-bit to 4-bit keypad code converter model
// converts 4-bit keypad code into a 4-bit 
// value expressed by Table 1 in Lab 4 
// assignment
module code_cnv(O,I);
   input [3:0] I;
   output reg [3:0] O;

	// add your modeling code here
	always @ (I)
             // straight-through connection
      //O = I; // add remove and replace with
             // code conversion model
				 
		case (I)
			0 : O = 1;
			1 : O = 4;
			2 : O = 7;
			3 : O = 14;
			4 : O = 2;
			5 : O = 5;
			6 : O = 8;
			7 : O = 0;
			8 : O = 3;
			9 : O = 6;
			10 : O = 9;
			11 : O = 15;
			12 : O = 10;
			13 : O = 11;
			14 : O = 12;
			15 : O = 13;
			default: O = I;
		endcase
				 
endmodule 