

module texter_control (clk, sw, dash_dit, dc_error, space, tm_reset, nxt_char, back_sp, nxt_bit, sp_load, out_char, out_space);

input clk, sw, dash_dit, dc_error, space;
output tm_reset, nxt_char, back_sp, nxt_bit, sp_load, out_char, out_space;

reg [2:0] state, nextstate;
reg tm_reset, nxt_char, nxt_bit, back_sp, sp_load, out_char, out_space;

initial
begin
state = 0;
nextstate = 0;
tm_reset = 0;
nxt_char = 0;
nxt_bit = 0;
back_sp = 0;
sp_load = 0;
out_char = 0;
out_space = 0;
end

always @(posedge clk)
begin
if (state == 0) begin
	if (sw) begin
		tm_reset = 1;
		nxt_char = 1;
		nextstate = 1;
		end
	else
		nextstate = 0;
end

else if (state == 1) begin
	if (sw) begin
		nextstate = 1;
	end
	else if (space) begin
	back_sp = 1;
	nextstate = 1;
	end
	else begin
		nxt_bit = 1;
		if (dash_dit) begin
			sp_load = 1;
		end
		nextstate = 2;
	end
end

else if (state == 2) begin
	tm_reset = 1;
	nextstate = 3;
end

else if (state == 3) begin
	if (sw) begin
		sp_load = 1;
		nextstate = 4;
	end
	else begin
		if (dash_dit) begin
			if (dc_error) begin
				nextstate = 0;
			end
			else begin
				out_char = 1;
				nextstate = 5;
			end
		end
		else begin
			nextstate = 3;
		end
	end
end

else if (state == 4) begin
	tm_reset = 1;
	nextstate = 1;
end

else if (state == 5) begin
	if (sw) begin
		nxt_char = 1;
		tm_reset = 1;
		nextstate = 1;
	end
	else begin
		if (space) begin
			out_space = 1;
			nextstate = 0;
		end
		else begin
			nextstate = 5;
		end
	end
end
state = nextstate;
end

endmodule



































