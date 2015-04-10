// Verilog  Module to input temperature data from the DS 1620 
// temperature IC
// template by
// B. Earl Wells, ECE Department University of Alabama in Huntsville
// inputs:
//    CLR an active high clear input which will reset internal signals 
//    and restart the temperature acquisition process
//    CLK_IN the input clock (must be less than 1 MHZ)
//    DQ_IN the input signal that is used to input data from the
//        external DS 1620 IC. The 1620 only produces this data in
//        response to a command issued from the external device that
//        occurred over the "three wire" communication port. When data
//        is sent from the DS 1620, it is in a bit serial manner. Such 
//        data is assumed to be valid at the rising edge of the CLK_OUT
//        signal. In this design the DQ_IN signal is used to receive
//        the 9 bit Celcius temperature from the DS 1620
// outputs:
//    TEMP the temperature acquired from the DS 1620 in 9 bit two's
//        complement format. (Output Resolution is 1/2 degree C)
//    CLK_OUT the clocking signal that drives the DS 1620 during its
//        "three wire" communication and the start conversion signal
//        that causes the DS 1620 to make the next temperature
//        conversion
//    RST the reset control line of the DS 1620 which is high during 
//        "three wire" communication but low in all other cases
//    TRI_EN the controling signal for the external tristate buffer.
//        This signal indicates when the DQ input of the external 
//        DS 1620 will be driven by DQ_OUT (this occurs when TRI_EN='1')
//        or when the DS 1620 will drive the DQ_IN input (this occurs 
//        when TRI_EN='0') 
//    DQ_OUT the output signal that drives the DS 1620 during "three 
//        wire" communication. Communication along this signal occurs 
//        in close coordination with the CLK_OUT signal. Such 
//        communication is bit serial with the valid logic value being 
//        placed on the DQ_OUT line at least 50 ns before the rising 
//        edge of CLK_OUT. Note in this design DQ_OUT is used to send 
//        the read temperature command to the DS 1620.

module DS1620_INTERFACE(input CLR, CLK_IN, output reg [8:0] TEMP,
   output reg CLK_OUT,RST,TRI_EN, input DQ_IN, output reg DQ_OUT);

reg [4:0] count = 0;
reg [8:0] dq_out_buff = 0;

//reg CLK_OUT, RST, TRI_EN;

//initial
//begin
	/*DQ_OUT = 0;
	TEMP = 0;
	CLK_OUT = 1;
	RST = 0;
	TRI_EN = 0;*/
//end

always @(CLK_IN)
begin

if (count > 1 && count < 19)
		CLK_OUT = CLK_IN;
		
if (CLK_IN == 1) // posedge
begin
	// Handle clk_out
	if (count == 26 || count == 27)
		CLK_OUT = 0;
	else if (!(count > 1 && count < 19))
		CLK_OUT = 1;
	
	if (CLR)
	begin
		count = 1;
		dq_out_buff = 0;
		TEMP = 0;
		CLK_OUT = 1;
	end
	else // CLR not set
	begin
		/*if (count > 31) begin
			count = 1; // Proceed to loop
		end*/
		
		// Handle RST output
		if (count < 20) begin
			RST = 1;
		end
		else begin
			RST = 0;
		end
		
		// Handle DQ_OUT
		if (count == 2 || count == 4 || count == 6 || count == 8) begin
			DQ_OUT = 0;
		end
		else begin
			DQ_OUT = 1;
		end
		
		// Handle TRI_EN output
		if (count > 1 && count < 11) begin
			TRI_EN = 1;
		end
		else begin
			TRI_EN = 0;
		end
		
		// Handle Filling dq_out_buff
		if (count > 9 && count < 19) begin
			dq_out_buff = dq_out_buff << 1; // make room to load next input
			dq_out_buff[0] = DQ_IN;
		end
		
		// Handle TEMP output
		if (count == 19) begin
			TEMP = ((~dq_out_buff)+1);
		end
		
		// Reset buffer
		if (count == 8)
			dq_out_buff = 0;
		
		count = count + 1; // Prep for next clock cycle
	end
end



end
endmodule



















