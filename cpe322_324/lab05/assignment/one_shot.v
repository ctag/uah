//- one_shot Module-----------------------------------------------
// This module creates a single positive pulse that has
// the same width as the period of its input clock
// the clock pulse after the input, i_, goes from
// Logic 1 to Logic 0. Only one pulse will be generated
// by the cirucit no matter how long the input is held
// to a Logic 0. The input must go back to a Logic 1
// for at least one clock cycle and back to a Logic 0
// before the next positive (Logic 0-to Logic 1-to Logic 0)
// transition.
//
// B. Earl Wells, February 10, 2015
// University of Alabama in Huntsville
module one_shot(output reg o, input clk,input i_);
   reg [0:0] state;

   initial
      state=0;
	
   always @ (posedge clk)
      if (state==0) 
         if (!i_)        // if input is 0 and in normal state
            begin
               o=1;     // output a Logic 1
               state=1; // go to state 1--already been triggered state
            end
         else
            begin       // if input is 0 and in normal state
               o=0;
               state=0;
            end
      else
         begin         // In state 1 --already triggered state
            o=0;       // output will always be Logic 0 in this state
            if (!i_)
               state=1; // input is 0 remain in this state
            else
               state=0; // input is 1 go back to state 0 (normal state)
            end
			   
endmodule
				
