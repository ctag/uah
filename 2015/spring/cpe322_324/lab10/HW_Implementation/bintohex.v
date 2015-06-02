// Single Button Texter -- binary to Seven Segment LED converter
// bintohex.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
module bintohex (input [3:0] i, output reg [6:0] o);

   always @ (i)
      case (i)
         0  : o <= 7'b1000000;
         1  : o <= 7'b1111001;
         2  : o <= 7'b0100100;
         3  : o <= 7'b0110000;
         4  : o <= 7'b0011001;
         5  : o <= 7'b0010010;
         6  : o <= 7'b0000010;
         7  : o <= 7'b1111000;
         8  : o <= 7'b0000000;
         9  : o <= 7'b0011000;
         10 : o <= 7'b0001000;
         11 : o <= 7'b0000011;
         12 : o <= 7'b1000110;
         13 : o <= 7'b0100001;
         14 : o <= 7'b0000110;
         15 : o <= 7'b0001110;
         default : o <= 7'bx;
      endcase

endmodule
