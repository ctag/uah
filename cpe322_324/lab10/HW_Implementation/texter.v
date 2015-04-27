// Single Button Texter -- main Single Button Texter module
// -- texter.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
module texter(input reset,clk,sw, output bk_space,done,key_bk_space,
   reset_nt, output [7:0] ascii_out,sp_wpm);

   // internal nodes and busses
   wire n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10;
   wire [8:0] b0,b1;

   assign reset_nt = n0;
   assign n0 = ~reset;
   assign key_bk_space = n1 & n2;

   debounce C0(.clk(clk),.d_in(sw),.d_out(n1));

   texter_control C1(.clk(clk),.reset(n0),.sw(n1),.space(n2),
      .dash_dit(n3),.dc_error(n4),.nxt_bit(n5),.nxt_char(n6),
      .out_char(n7),.out_space(n8),.tm_reset(n9),.sp_load(n10),
      .back_sp(bk_space));

   decoder C2(.clk(clk), .d_in(n3),.nxt(n5),.reset(n6),.out_char(n7),
      .out_space(n8),.error(n4),.done(done),.ascii_out(ascii_out));

   sat_counter C3(.clk(clk),.reset(n9),.ref_in(b0),.dash_dit(n3),
      .space(n2),.count_out(b1));

   speed_tracker C4(.clk(clk),.load(n10),.dashdit(n3), 
      .lst_count(b1),.ref_out(b0));

   speed_io C5(.num_in(b0),.bcd_out(sp_wpm));

endmodule

