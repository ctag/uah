// This module generates the scan and debounce clocks pulses
// that are derived from the 50 Mhz Input clock on the DE2-115
// board using clock division methods
module clock_gen(clk_in,scan_en,scan_clk,debounce_clk);
   input clk_in,scan_en;
	output scan_clk,debounce_clk;
	reg [16:0] count;
	
   assign scan_clk = (scan_en) ? count[16]: scan_clk;
	assign debounce_clk = count[12];
	
	always @ (posedge clk_in)
      begin	
		count <= count + 17'd1;
      end
endmodule
