// Single Button Texter -- decoder module -- decoder.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// This module that coverts the dit/dash pattern into 8 bit ASCII 
// encodings. An active high on the reset input resets the decoder
// allowing it to begin the interpretation of the next character.
// The main input to the routine is to be placed on the d_in signal
// where a logic 1 represents a dash (3 units of switch down) and a
// logic 0 represents a dit (one unit of the switch being pressed). 
// The nxt input is an active high signal that is used to strobe the
// data into the decode module and should be one clock cycle in
// duration. The out_char line is used to cause the decoder module to
// produce the ASCII value of the Morse code pattern on its ASCII_OUT
// output and to produce the one cycle active high strobing signal 
// done which is used to drive the LCD and VGA output modules. The 
// out_space input signal causes the decoder module to place an ASCII
// space value on the ascii_out port and to strobe this value out
// regardless of the state of the internal decoding. If the decoder
// module receives the pattern dit dit dash dash (. . _ _) then it
// toggles an internal case flag allowing the user to change from
// upper to lower case lettering.
module decoder (input clk, d_in, nxt, reset, out_char, out_space,
   output reg [7:0] ascii_out, output reg error, done);

   // lookup table implementation of Morse to ascii translation, where
   // the input value is obtained by left shifting dash/dit values 
   // into a buffer to the left when the initial value in the 7 bit 
   // buffer was set to 8'hfe.
   reg [6:0] xref [0:127];

   initial
      begin
      xref[0] = 7'b0001000;    xref[1] = 7'b0000000;
      xref[2] = 7'b0000000;    xref[3] = 7'b0000000;
      xref[4] = 7'b0000000;    xref[5] = 7'b0000000;
      xref[6] = 7'b0000000;    xref[7] = 7'b0000000;
      xref[8] = 7'b0000000;    xref[9] = 7'b0100100;
      xref[10] = 7'b0000000;   xref[11] = 7'b0000000;
      xref[12] = 7'b0111111;   xref[13] = 7'b0000000;
      xref[14] = 7'b0000000;   xref[15] = 7'b0000000;
      xref[16] = 7'b0000000;   xref[17] = 7'b0000000;
      xref[18] = 7'b0000000;   xref[19] = 7'b0000000;
      xref[20] = 7'b0000000;   xref[21] = 7'b0101110;
      xref[22] = 7'b0000000;   xref[23] = 7'b0000000;
      xref[24] = 7'b0000000;   xref[25] = 7'b0000000;
      xref[26] = 7'b0000000;   xref[27] = 7'b0000000;
      xref[28] = 7'b0000000;   xref[29] = 7'b0000000;
      xref[30] = 7'b0100111;   xref[31] = 7'b0000000;
      xref[32] = 7'b0000000;   xref[33] = 7'b0101101;
      xref[34] = 7'b0000000;   xref[35] = 7'b0000000;
      xref[36] = 7'b0000000;   xref[37] = 7'b0000000;
      xref[38] = 7'b0000000;   xref[39] = 7'b0000000;
      xref[40] = 7'b0000000;   xref[41] = 7'b0000000;
      xref[42] = 7'b0111011;   xref[43] = 7'b0000000;
      xref[44] = 7'b0000000;   xref[45] = 7'b0101000;
      xref[46] = 7'b0000000;   xref[47] = 7'b0000000;
      xref[48] = 7'b0000000;   xref[49] = 7'b0000000;
      xref[50] = 7'b0000000;   xref[51] = 7'b0101100;
      xref[52] = 7'b0000000;   xref[53] = 7'b0000000;
      xref[54] = 7'b0000000;   xref[55] = 7'b0000000;
      xref[56] = 7'b0111010;   xref[57] = 7'b0000000;
      xref[58] = 7'b0000000;   xref[59] = 7'b0000000;
      xref[60] = 7'b0000000;   xref[61] = 7'b0000000;
      xref[62] = 7'b0000000;   xref[63] = 7'b0000000;
      xref[64] = 7'b0110101;   xref[65] = 7'b0110100;
      xref[66] = 7'b0000000;   xref[67] = 7'b0110011;
      xref[68] = 7'b0000000;   xref[69] = 7'b0000000;
      xref[70] = 7'b0000000;   xref[71] = 7'b0110010;
      xref[72] = 7'b0000000;   xref[73] = 7'b0100010;
      xref[74] = 7'b0000000;   xref[75] = 7'b0000000;
      xref[76] = 7'b0000000;   xref[77] = 7'b0000000;
      xref[78] = 7'b0000000;   xref[79] = 7'b0110001;
      xref[80] = 7'b0110110;   xref[81] = 7'b0000000;
      xref[82] = 7'b0101111;   xref[83] = 7'b0000000;
      xref[84] = 7'b0000000;   xref[85] = 7'b0000000;
      xref[86] = 7'b0101001;   xref[87] = 7'b0000000;
      xref[88] = 7'b0110111;   xref[89] = 7'b0000000;
      xref[90] = 7'b0000000;   xref[91] = 7'b0000000;
      xref[92] = 7'b0111000;   xref[93] = 7'b0000000;
      xref[94] = 7'b0111001;   xref[95] = 7'b0110000;
      xref[96] = 7'b1101000;   xref[97] = 7'b1110110;
      xref[98] = 7'b1100110;   xref[99] = 7'b0000000;
      xref[100] = 7'b1101100;  xref[101] = 7'b0000000;
      xref[102] = 7'b1110000;  xref[103] = 7'b1101010;
      xref[104] = 7'b1100010;  xref[105] = 7'b1111000;
      xref[106] = 7'b1100011;  xref[107] = 7'b1111001;
      xref[108] = 7'b1111010;  xref[109] = 7'b1110001;
      xref[110] = 7'b0000000;  xref[111] = 7'b0000000;
      xref[112] = 7'b1110011;  xref[113] = 7'b1110101;
      xref[114] = 7'b1110010;  xref[115] = 7'b1110111;
      xref[116] = 7'b1100100;  xref[117] = 7'b1101011;
      xref[118] = 7'b1100111;  xref[119] = 7'b1101111;
      xref[120] = 7'b1101001;  xref[121] = 7'b1100001;
      xref[122] = 7'b1101110;  xref[123] = 7'b1101101;
      xref[124] = 7'b1100101;  xref[125] = 7'b1110100;
      xref[126] = 7'b1111111;  xref[127] = 7'b0000000;
      end

   always @ (posedge clk)
      begin:MAIN_LOOP
      reg [6:0] code = 7'b1111110;
      reg [7:0] ascii_buf = 8'd0;
      reg caps_on_off = 1;
      done = 0;
      if (reset)
         begin
         //  if (. . _ _) pattern toggle case flag
         if (code == 7'b1100011)
            caps_on_off = ~caps_on_off;
         code = 7'b1111110;
         end
      else
         if (nxt)
            begin
            // if nxt signal is active shift the Dash/Dit value on 
            // d_in into the codeword to the left one position
            code = {code[5:0],d_in};
            if (!xref[code])
               // if ASCII value is found to be 0 then illegal 
               // charcter found 
               error = 1; // set error output flag 
            else
               // if not clear error output flag
               error = 0;
            end
         else
            // if output character signal is high then output 
            // the next charcter
            if (out_char)
               begin
               ascii_buf = {1'b0,xref[code]};
               if (ascii_buf > 8'd96 && ascii_buf < 8'd123)
                  // if alpha character change case if necessary
                  ascii_buf[5] = caps_on_off; 
               ascii_out = ascii_buf;  // output character
               done = 1;               // strobe done signal
               end
            else
               // if out_space signal asserted and a valid character 
               // is present then output a space
               if (out_space && ascii_buf)
                  begin
                  ascii_out = 8'b00100000; // send ASCII space char
                  done = 1;                 // strobe DONE signal
                  end 
      end
                  
endmodule

