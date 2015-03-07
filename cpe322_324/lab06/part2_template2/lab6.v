// CPE 324 Solution File for Part 2 of Lab 6
// Behavioral Model of Capacitance Tester
// B. Earl Wells
// February 20, 2015

module lab6(input SIG,CLOCK_50,output [6:0] HEX3,HEX2,HEX1,HEX0);

   reg l_flg; // this is a flag that may be used in your behavioral
              // design to allow a count value to be latched and 
              // cleared when SIG=1
              
   reg [10:0] count;     // cap 0.01 uf discharge time count
   reg [13:0] bin_count; // cap value count (binary value)
   reg [15:0] bcdout;    // bcd representation of cap value count
   
   reg sig; // debounced version of input SIG
   initial
      begin
      l_flg=0;
      count=0;
      end
   
   // 50 Mhz is very fast compared to the rise and fall times
   // of the 555 output so a simple one stage debounce may
   // be useful to stop miss readings -- this debounce 
   // sections requires SIG to be constant for at least two
   // consecutive 50 Mhz clock cycles before the debounced 
   // version of SIG (i.e. named sig) is allowed to transition    
   always @ (posedge CLOCK_50)
       begin:SIG_debounce
       
       reg last_sig;
     
       if (sig)
         begin    
         if (!SIG & !last_sig) sig=0;
         end
       else
         begin
           if (SIG & last_sig) sig=1;
         end
       last_sig = SIG;
       end  
   
   // ADD YOUR MODELING CODE IN THIS SECTION!!!
   // may want to use the bintohex task and the bintobcd function
   // on the rising edge of your main clock, CLOCK_50, 
   // Do the following using an always @ procedural statement:
   always @(posedge CLOCK_50)
      begin
      // measure the number of 0.01 uf time periods when sig=0 
      if (!sig)
         begin
   
         // check to see if the 0.01 uf cap discharge time counter is
         // that is driven by the 50 Mhz clock is less than the
         // maximum count value -- if this is the case increment 
         // the value by one
         if (count<????)
            count = count + 1;
         else
         
            begin
            // if the 0.01 uf cap discharge time counter has reached its
            // max allowed value check to see if the SIG input is low
            // if it is then that means we should reset the 0.01 uf
            // count value to 0 to start a new count cycle
         
            // reset the 0.01 uf discharge time counter
         
                     
            //  increment cap value count by 1. Do this only
            //  if cap value count has not reached the 9999 max. This will
            //  stop wrap around for capacitors that have capacitances that 
            //  are out of range.
          
            
            // Set the l_flg to enable first pass latching of display
            // variables and the clearing of binary count the next time
            // SIG is equal to a logic 1
          
            end
         end
         
      // On the first clock cycle that sig=1 convert and latch the output
      // data taken during the time sig=0, clear the binary cap value count
      // and initialize the 0.01 uf time counter to its midrange value
      else
         begin
         // when l_flg is true it is the first 50 Mhz clock cycle that
         // sig = 1 

            //  convert from the capacitance binary count to
            //  a 16-bit BCD capacitance count value
            //    (use the bintobcd function)
            
            // drive the appropriate seven segment dispaly (use
            // the bintohex task)
            
            // clear the capacitance binary count value
            
            // set the 0.01 uf capacitance counter to the midrange
            // value to allow it to be offset by one half of its
            // maximum value -- this allows it to round up values
            // at the least sigificant position
            
            // reset the l_flg to false -- this allows only one
            // pass through this outputing and reseting phase
            
         end
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

   // This is a user-defined function that returns a 16-bit BCD 
   // value from a 14-bit unsigned binary value
   function [15:0] bintobcd;
      input [13:0] bin_num;
      reg [15:0] bcd_num=0;

      reg [3:0] i;
      for (i=0;i<=3;i=i+1)
         begin
            bcd_num=bcd_num+((bin_num-(bin_num/5'd10)*5'd10)<<4'd4*i);
            bin_num = bin_num/5'd10;
         end
      bintobcd=bcd_num; 
   endfunction

endmodule

