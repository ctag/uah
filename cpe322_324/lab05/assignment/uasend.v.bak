//- uasend Module-------------------------------------------------
// Universal Asynchronous serial Sender module.
// Function is to output in an asynchronous serial manner parallel
// data that is present on its 8-bit parallel input port.
// Inputs:
//     data_in -- 8-bit input data
//     clk     -- master (global) clock
//     en      -- active high enabling signal to be driven with pulses 
//                that have a width equal to the period of the global
//                clock but are sent at a frequency equal to the 
//                baud rate
//     go      -- active high activation signal that causes the data
//                latched from the 8-bit input port to be sent serially
//  Outputs:
//     serial_out -- single bit output line driven in a manner that 
//                   corresponds
//                   to the asynchronous protocol 
module uasend(input go,clk,en, input [7:0] data_in, output serial_out);

   wire	n0,n1;

   send_control_logic C0(.go(go),.en(en),.clk(clk),.l(n0),.s(n1));

   shift_reg_10_l_en  C1(.l(n0),.en(n1),.clk(clk),
      .din({1'b1,data_in,1'b0}),.dout(serial_out));

endmodule

//-send_control_logic Module--------------------------------------
// This is the main sender control logic module that is to be 
// developed by cpe324 for the laboratory assignment
module send_control_logic(input go,en,clk, output reg l,
   output reg s);

   reg [3:0] state,next_state; // may want to use these

   // Enter your modeling code here!

      // include register update portion

      // include combinational logic portion

endmodule

//-shift_reg_10_l_en Module---------------------------------------
// 10 bit shift register with enabled shift and priority load.
// Data is assumed to be shifted out left to righ with LSB first.
// Counter ignores shift commands when en is high but loads into
// the shift register parallel data on its 10-bit input port 
// on the next active clock when l is high.
// Inputs: 
//    din -- 10-bit parallel data
//    l   -- loads parallel data into the shift-register 
//    clk -- global clock
//    en  -- clock enable input (active high)
//           logic high causes shift register to shift one bit position
//           to the right at the next active edge
//           of the clock.
// Output:
//    dout -- serial output bit 
module shift_reg_10_l_en(input [9:0] din,input l,en,clk,
   output reg dout);
   reg [9:0] sendbuf;

   initial
      dout=1;

   always @ (posedge clk)
      if (l)
         begin
            sendbuf = din;
         end
      else
         if (en)
            begin
               dout=sendbuf[0];
               sendbuf=(sendbuf>>1);
            end
endmodule