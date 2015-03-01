
// Christopher Bero


// HW2 - Part 2 - Moore FSM
module moore_fsm(input Bin,clk,reset, output reg Bout);

   reg [3:0] state,next_state;
	
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4;
  
	always @ ( posedge clk)
	begin
			case (state)
			  			      
				S0:
				begin
				  Bout = 0;
				if (Bin)
					next_state = S3;
				else
				  next_state = S1;
				end
				
				S1:
				begin
				  Bout = 0;
				if (Bin)
					next_state = S2;
				else
				  next_state = S3;
				end
				
				S2:
				begin
				  Bout = 1;
				if (Bin)
					next_state = S2;
				else
				  next_state = S3;
				end
				
				S3:
				begin
				  Bout = 1;
				if (Bin)
					next_state = S4;
				else
				  next_state = S3;
				end
				
				S4:
				begin
				  Bout = 0;
				if (Bin)
					next_state = S4;
				else
				  next_state = S3;
				end
				
			endcase
			
			if (reset)
			    begin
			      state = S0;
			      Bout = 0;
			    end
			else
      			state = next_state;
		
	end

endmodule