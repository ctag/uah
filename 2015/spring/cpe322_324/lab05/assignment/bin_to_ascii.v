//- bin_to_ascii Module----------------------------------------
// simple 4-bit binary to 8-bit ASCII code
// code should convert from the 4-bit code coming from the
// keypad interface into an 8-bit ASCII code that has the same
// symbol that is on the corresponding key of the keypad
// Input: 
//    I[3:0] -- 4-bit input value
//    O[7:0] -- 8-bit ASCII Code that corresponds to key
//
module bin_to_ascii(output reg [7:0] O,input [3:0] I);

always @ (I)
		case (I)
		// Input		  Output
			0 		: 	  O <= 48;
			1     :    O <= 49;
         2     :    O <= 50;
         3     :    O <= 51;
         4     :    O <= 52;
         5     :    O <= 53;
         6     :    O <= 54;
         7     :    O <= 55;
         8     :    O <= 56;
         9     :    O <= 57;
         10    :    O <= 65;
         11    :    O <= 66;
         12    :    O <= 67;
         13    :    O <= 68;
         14    :    O <= 69;
         15    :    O <= 70;
			default:   O <= 33;
		endcase
endmodule

