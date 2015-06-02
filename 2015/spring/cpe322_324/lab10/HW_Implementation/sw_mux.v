// Single Button Texter -- testbench switch multiplexer module
// -- sw_mux.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// Switch Multiplexer Component
// this routine selects between the switch as a keying source and
// the keying source supplied by the switch driver module. It also
// supplies a active low reset output whenever the switch is selected
// as the keying source, thereby disabling the switch driver module. 
module sw_mux (input i0,i1,sel, output sw_resetn,sw_out);

   reg sel_st;

   initial
      sel_st=0;

   always @ (negedge sel)
         sel_st <= ~sel_st;

   assign sw_out = (i0 & (~sel_st)) | ((~i1)&sel_st);
   assign sw_resetn = sel_st;

endmodule 
