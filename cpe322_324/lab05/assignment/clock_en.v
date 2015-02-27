//- clock_en Module-----------------------------------------------
// Clock Enabler Module
// supports fully synchronous design by supplying two periodic enable
// pulse signals. In both cases the width of the pulse is equal to
// the period of the master input clock. One is enabling signal is
// produced that has a frequency that is set at 16 times the specified 
// baud rate and the other produces enabling pulses at the same rate
// as the specified baud rate. This implementation has been sized
// to produce enabling pulses for a targetted baud rate of 9600 baud.
// Inputs:
//   clk -- 50 Mhz base clock
// Outputs:
//    en_out_16 -- one clock period duration enabling pulses sent at a
//                 16 times the desired baud rate of 9600 (16x9600)
//    en_out    -- one clock period duration enabling pulses sent 
//                 at the specified 9600 bps baud rate.
//    Note: these are approximate frequencies obtained from dividing
//          the base clock which is assumed to be 50 Mhz.
//			         
//  B. Earl Wells, UAH, February 10, 2015

module clock_en(output reg en_out16,en_out, input clk);
   reg [8:0] count1;
   reg [3:0] count2;

   always @(posedge clk)
      begin
         en_out = 0;   // default values of enabling signals
         en_out16 = 0; // always set to 0 
         if (count1==325) // approx number of 50 Mhz clock cycles 
                          // in one 16x9600 clock cycle
            begin
               en_out16 = 1; // output en_out16 pulse
               count1 = 0;   // reset base counter for next 
                             // 16x9600 cycle

                  if (count2==15) // every 16 cycles of 16x9600 clock 
                     begin
                        en_out = 1; // output an en_out pulse
                        count2 = 0; // reset inner counter
                     end
                  else
                     begin // if 16 base cycles have not completed
                        count2 = count2 + 1;// increment inner counter
                     end
            end
         else
            begin      // if 16x9600 clk cycles have not completed yet
               count1 = count1 + 1; // increment base counter
            end
      end	
endmodule
