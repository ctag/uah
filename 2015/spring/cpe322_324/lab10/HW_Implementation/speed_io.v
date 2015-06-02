// Single Button Texter -- speed monitoring module
// -- speed_io.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// This module that converts the saturation counter 9-bit reference
// value into the approximate BCD representation of the speed of
// the text in Words per Minute (WPM)
// Note: this module utilizes general integer division which is 
//       not usually efficiently implemented in synthesis
//       a more efficient implementation may be possible using
//       a lookup table scheme
module speed_io(input [8:0] num_in, output reg [7:0] bcd_out);

   always @ (num_in)
      begin:speed
         reg [10:0] speed_val;
         // make sure division utilizes all 11 bits in 1665 constant
         speed_val = 11'd1665/{1'b0,1'b0,num_in}; 
         bcd_out = bintobcd(speed_val[8:0]);
      end

   // This is a user-defined function that returns an 8-bit BCD 
   // value from a 9-bit unsigned binary value
   function [7:0] bintobcd;
      input [8:0] bin_num;
      reg [7:0] bcd_num=0;
      begin
         bcd_num=bcd_num+((bin_num-(bin_num/10)*10));
         bin_num = bin_num/10;
         bcd_num=bcd_num+((bin_num-(bin_num/10)*10)<<4);
      end 
      bintobcd=bcd_num; 
   endfunction

endmodule

