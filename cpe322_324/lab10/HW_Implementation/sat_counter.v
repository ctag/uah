// Single Button Texter -- saturation counter module
// -- sat_counter.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// This module is a 9-bit binary saturation type counter that begins
// its count sequence at "000000000" and counts up to "111111111" at
// which point it stops the count until it is reset back to "000000000"
// when a Logic 1 is placed on the reset input. The counter has 
// prescaling logic built into it that allows for each effective count
// of the counter to be 60000 actual clock cycles of the 27 Mhz system
// clock input clk. This module is responsible for using the time 
// period between resets to determine the appropriate time period for
// a dit (one unit), a dash or space between charcters (three units), 
// or the minimum time period of a space between words. (approximately
// seven units). It does this by accepting a nine bit reference time
// that should be approximately 2 units in value, meaning that at time
// that is less than the reference time should be interpreted as a dit
// (dash_dit output being reset to 0) and a time period that
// is greater than this number being interpreted as a dash or a space
// between characters (in both cases the dash_dit output would be set
// to 1). If the time period between resets is over six units the 
// space signal will be set to 1 otherwise it will be reset to 0. The
// value of the 9-bit count reference is provided by the speed tracking
// module speed_tracker and is adjusted throughout the session.
module sat_counter (input clk, reset, input [8:0] ref_in,
   output reg [8:0] count_out, output reg dash_dit, space); 

   always @ (posedge clk)
      begin:MAIN_LOOP
      reg [15:0] m_count = 16'd0; // counter prescaler value
      reg [11:0] count = 12'd0;   // counter value
      reg [11:0] sp_ref;
      if (reset)
         begin
         count = 12'd0;   // clear count
         m_count = 16'd0; // reset internal prescaler count
         // set internal space reference value
         // to approximately 3 * current
         sp_ref = {3'b000,ref_in} + {2'b00,ref_in,1'b0};
         end
      else 
         if (m_count < 60000)
            m_count = m_count+1; // increment internal prescale counter
         else
            begin
            // when internal prescale count is at max perform 
            // normal count operation then stop counting when
            // counter has reached its limit   
            m_count = 0;
            if (count < 12'b011111111111) 
               count = count + 1;
            end

      // set dash_dit if count exceeds Reference value
      if (count <= {2'b00,ref_in})
         dash_dit = 0;
      else
         dash_dit = 1;

      // if count is greater the space reference value then set 
      // space output to 1
      if (count <= sp_ref)
         space = 0;
      else
         space = 1;

      // if count value is greater than a 9 bit value hold this count
      // on the output. If not output value of count divided by 2
      if (count >=   12'b000111111111)
         count_out = 9'b111111111; 
      else 
         count_out = count[8:0]; 
      end

endmodule   

