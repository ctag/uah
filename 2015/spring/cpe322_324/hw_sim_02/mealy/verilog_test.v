// Christopher Bero


// HW2 - Part 1 - Mealy FSM
module twos_complement(input Bin,clk,reset, output reg Bout);

   reg [3:0] state,next_state;
	
	parameter S0 = 0, S1 = 1, S2 = 2;
  
	always @ ( posedge clk)
	begin
			case (state)
			  			      
				S0:
				begin
				  Bout = Bin;
				if (Bin)
					next_state = S2;
				else
				  next_state = S1;
				end
				
				S1:
				begin
				  Bout = 1;
				if (Bin)
					next_state = S1;
				else
				  next_state = S2;
				end
				
				S2:
				begin
				  Bout = ~Bin;
				if (Bin)
					next_state = S2;
				else
				  next_state = S2;
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