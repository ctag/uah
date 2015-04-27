// Single Button Texter -- texter control module
// -- texter_control.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// This is the main texter_control module for the single button texter.
// This module should implement the design that was described by the
// ASM Chart that was presented in Laboratory 10 of the class. 
// The design is to be reset to state S0 whenever the reset signal is
// at a logic high. Whenever the reset signal is at a logic low it 
// should fully implement the state machine specified by the SM chart. 
// The clock signal is assumed to be a 50% duty cycle clock that is the
// same clock that drives the other functional units that
// are being controlled by this module (27 Mhz on the DE-2). The other
// input and output signals are all assumed to be active high. The 
// input signal, sw, is controlled by the user and the other inputs 
// are status inputs that come directly from the functional units
// that are being controlled. These inputs will change their states in
// direct response to your controlling outputs that you provide. The 
// outputs are all assumed to be active for a one clock duration as 
// indicated by the ASM chart.
module texter_control(input clk, reset, sw, space, dash_dit, dc_error,
   output reg nxt_bit, nxt_char, out_char, out_space, tm_reset,
   sp_load, back_sp);

   // enter your modeling code here

endmodule
