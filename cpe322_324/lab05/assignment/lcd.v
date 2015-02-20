//---------------------------------------------------------------------
// This module outputs to the LCD at the current cursor location
// the character that is specified by the ascii_in value whenever
// the input ds is strobed high for one clock cycle.
// It will also backspace one position whenever the ASCII backspace
// character is sent.
// Cursor is returned to the begining position and the LCD is cleared
// whenever the reset signal is at a logic high.
// Module is written behaviorally
// 
// B. Earl Wells, February 10, 2015
// University of Alabama in Huntsville

module lcd(input clk, input [7:0] ascii_in, input ds, 
   output reg rs, output reg rw, output reg en, 
   output reg lcdon, output reg lcdblon,
   output reg [7:0] data_out);

   reg ds_buf; // data strob buffer signal
   reg [5:0]  lcount;
   reg [20:0] lwait;
   reg [3:0]  state; // current state
   reg [4:0]  ch_num;
   reg [7:0]  add_out;
   reg c_flg1,c_flg2;

   initial
      begin
         ds_buf=0;
         lcount=0;
         lwait=0;
         state=0;
         ch_num=0;
         c_flg1=0;
         c_flg2=0;
         lcdon=1;
         lcdblon=1;
      end

   // State Machine implementation of the basic LCD communication 
   // protocol. States 0 through 6 implement the initilization protocol
   // for the device. States 7 through 10 implement the cursor
   // positioning and the writing of ASCII data to the Data RAM
   // inside the LCD (as well as backspacing to the previous cursor
   // position within the LCD's Data RAM.
   always @ (posedge clk)
      begin
		
         if (ds) ds_buf = 1;

         case (state)
            0 : begin
                // wait at least 15 ms then set LCD interface to 8 bits
                if (!c_flg1) 
                   delay(1500000,c_flg1);
                else
                   begin
                      write_data(8'b00110000,0,c_flg2);
                      if (c_flg2)
                         begin
                            c_flg1 = 0;
                            state = 1;
                         end
                   end
                end
            1 : begin
                // wait at least 4.1 ms and then again set LCD iterface
                // to 8 bits -- evidently the LCD is hard of hearing
                if (!c_flg1)
                   delay(600000,c_flg1);
                else
                   begin
                      write_data(8'b00110000,0,c_flg2);
                      if (c_flg2)
                         begin
                            c_flg1 = 0;
                            state = 2;
                         end
                   end
                end
            2 : begin
                // wait at least 100us and then once again set LCD
                // iterface to 8 bits -- YES the LCD IS hard of hearing!!
                if (!c_flg1)
                   delay(150000,c_flg1);
                else
                   begin
                      write_data(8'b00110000,0,c_flg2);
                      if (c_flg2)
                         begin
                            c_flg1 = 0;
                            state = 3;
                         end 
                   end
                end
            3 : begin
                // wait at least 39 us and set the display again for
                // 8 bits but with 2 lines with font 5x8 dots
                if (!c_flg1)
                   delay(150000,c_flg1);
                else
                   begin
                      write_data(8'b00111000,0,c_flg2);
                      if (c_flg2)
                         begin
                            c_flg1=0;
                            state=4;
                         end
                   end 
                end
            4 : begin
                // wait at least 39 us and 
                // set the display to on, with blinking cursor
                if (!c_flg1)
                   delay(150000,c_flg1);
                else
                   begin
                      write_data(8'b00001111,0,c_flg2);
                      if (c_flg2)
                         begin
                            c_flg1=0;
                            state=5;
                         end
                   end
                end
            5 : begin
                // wait at least 1.53 ms and 
                // clear the display
                if (!c_flg1)
                   delay(150000,c_flg1);
                else
                   begin
                      write_data(8'b00000001,0,c_flg2);
                      if (c_flg2)
                         begin
                            state=6;
                         end
                   end
                end
            6 : begin
                // wait at least 39 us and 
                // Assign cursor moving direction and shift enable
                if (!c_flg1)
                   delay(150000,c_flg1);
                else
                   begin
                      write_data(8'b00000111,0,c_flg2);
                       if (c_flg2)
                          begin
                             c_flg1=0;
                             state=7;
                          end
                   end 
                end
            7 : begin
                // waiting state for next charcter
                if (ds_buf)
                      if (ascii_in == 8'b00001000)
                         begin              // if backspace character 
                            ch_num=ch_num-1;// then decrement character 
                            c_flg1=1;       // address and start space 
                         end                // over process
                      else
                         begin
                            c_flg1=0;
                            c_flg2=0;
                            ds_buf=0;
                         end
                else  
                   if (!c_flg2)
                      begin
                         // output current cursor location to LCD 
                         // control memory
                         add_out={1'b1,ch_num[4],2'b00,ch_num[3:0]};
                         write_data(add_out,0,c_flg2);
                         if (c_flg2)
                            if (!c_flg1) 
                               // if no backspace then nextstate 
                               // is state 8
                               state=8;
                            else
                               begin
                                  // if backspace the nextstate is state 9
                                  c_flg1=0;
                                  state=9;
                               end 
                      end
                end
            8 : begin
                // write ASCII value to Data RAM of LCD 
                if (!c_flg1)
                   delay(15000,c_flg1);
                else
                   begin
                      write_data(ascii_in,1,c_flg2);
                      if (c_flg2)
                         begin
                            ch_num = ch_num + 1;
                            c_flg1=0;
                            state = 7;  // wait for next character in state 7  
                         end
                   end
                end
            9 : begin
                // output ASCII space charcter at current cursor location
                if (!c_flg1)
                   delay(15000,c_flg1);
                else
                   begin
                      // write space charcter
                      write_data(8'b00100000,1,c_flg2);
                      if (c_flg2)
                         begin
                            c_flg1=0;
                            state=10;
                         end
                   end
                end
           10 : begin
                // output decremented cursor location to LCD RAM control mem
                if (!c_flg1)
                   delay(15000,c_flg1);
                else
                   begin
                      add_out={1'b1,ch_num[4],2'b00,ch_num[3:0]};
                      write_data(add_out,0,c_flg2);
                      if (c_flg2)
                         begin
                            c_flg1=0;
                            state=7;
                         end
                   end
                end
         endcase
   end




   // This Verilog task implements the LCD write protocol for the 
   // 32 character (2x16) LCDs which actually represents an industry
   // standard protocol. It is placed in a mode that uses the full 
   // 8 bits of the LCD's data bus. In this protocol the LCD is 
   // treated like a memory mapped peripherial. Its Register 
   // Select (RS), clock (E), Enable  (EN), and Read/write (RW) signals
   // are all driven in the proper sequence as dictated by the protocol
   // by the task. Note that the LCOUNT variable is an inout parameter
   // that is global to the module that called this task.

   // The LCD is a very slow device compared to the speeds of the FPGA.
   // The major use of this task is to ensure that external control
   // signals are applied to the LCD module at the proper time in 
   // the protocol so that none of the LCD's setup or hold times are 
   // violated.
   task write_data(input [7:0] data_in, input rs_in,
      output c_flg);
      begin
         rw = 0;
         lcount = lcount + 1;
         if (lcount == 1) 
            rs = rs_in;
         if (lcount > 3 && lcount < 29)
            en = 1;
         else 
            en = 0;
         if (lcount == 5)
            data_out = data_in;
         if (lcount == 50)
            begin 
               c_flg = 1;
               lcount = 0;
            end
         else
            c_flg = 0;
      end
   endtask

   // This Verilog Task is used to delay the specified number of clock
   // counts so that the LCD has time to respond between data write 
   // operations.
   // Note: that the wcount variable is an inout variable to the task
   //       that is local to the calling module.
   task delay (input reg [20:0] endcnt,output c_flg);
      begin
         lwait = lwait + 1;
         if (lwait == endcnt)
            begin 
               c_flg = 1;
               lwait = 0;
            end
         else
            c_flg = 0;
      end
   endtask

endmodule
