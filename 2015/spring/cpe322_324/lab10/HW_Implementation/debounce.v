// Single Button Texter -- switch debounce module
// -- debounde.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// Verilog HDL module that debounces and inverts an input switch signal 
// (assumes a 27 Mhz clock)
// Inputs
//    clk:   27 Mhz system clock
//    d_in:  noisy switch input
// Output
//    d_out: clean inverted switch output
module debounce (input clk,d_in, output reg d_out);

   always @(posedge clk)
      begin:MAIN_LOOP
         reg [7:0] hld_sig = 8'd0;
         reg [4:0] index = 0;
         reg [14:0] count = 0;
         reg d_st = 0;       
         // increment internal prescaler counter until value is at max
         if (count == 20000)
            begin
            count = 0; // then evaluate debounce 
                       // invert signal and place in 8 bit array
            hld_sig[index] = ~d_in; 
            // implement a circular buffer
            if (index == 7)
               index = 0;
            else
               index = index + 1;
            // stay in state 0 until for 8 consecutive bit times the 
            // input signal has been at a logic 1
            if (!d_st)
               begin
               d_st = hld_sig[0]&hld_sig[1]&hld_sig[2]&hld_sig[3]&
                      hld_sig[4]&hld_sig[5]&hld_sig[6]&hld_sig[7];
               d_out = d_st;
               end
            // stay in state 1 until for 8 consecutive bit times the 
            // input signal has been at a logic 0 
            else
               begin
               d_st = hld_sig[0]|hld_sig[1]|hld_sig[2]|hld_sig[3]|
                      hld_sig[4]|hld_sig[5]|hld_sig[6]|hld_sig[7];
               d_out = d_st;
               end
            end
         else 
            // if COUNT value not at its max value increment it by one
            count = count + 1;
      end

endmodule


