// Single Button Texter -- speed tracking module
// -- speed_tracker.v file
// (c) 4/9/2015 B. Earl Wells, University of Alabama in Huntsville
// all rights reserved -- for academic use only.
//
// The Speed Tracker module provides the Saturation Counter module 
// with a 9 bit binary value that represents the approximate time
// that is between the 1 unit value (associated with a dot and the
// time between sounded units in a character) and the 3 unit value
// associated with a dash or the space between two consecutive
// characters.  This unit does this by keeping track on the last
// eight time values that were interpreted as dots and the last eight
// time values that were associated as dits and then averaging them
// together to get a value that lies in between these two values.
// New time values are placed on the lst_count input and in this
// design come from the sat_counter module. The reference time 
// is then placed on the ref_out output where it is used by the
// sat_timer to determine how to interpret the next period of time
// that the switch is in the active or inactive position. The 
// reference time value is strobed into this module whenever the
// load input is high. The value of the dashdit bit determines
// which eight time value arrays that the this timing information
// is placed. If the dashdit bit is one it is placed in the internal
// dash memory arry, if the dashdit bit is 0 it is placed in
// the dit memory arry. To simply the construction the averaging 
// is accomplished by subracting away old items from the total and 
// then adding the new item before performing a three bit shift of
// the result effectively dividing it by 8. There is also logic
// present to allow the tracker to recover from situations where
// all inputs are interpretted as dashes or dots. Such a situation
// can result when the speed changes too abruptly.
module speed_tracker (input clk, load, dashdit, input [8:0] lst_count,
   output reg [8:0] ref_out);
   reg [8:0] dt_time [0:7];
   reg [8:0] dh_time [0:7];

   initial
      begin:INIT_DT_DH
      reg [4:0] i;
      for (i=0;i<=7;i=i+1)
         begin
         dt_time[i]=9'd32;  // dit time array 
         dh_time[i]=9'd192; // dash time array
         end  
      end
   always @ (posedge clk)
      begin:MAIN_LOOP
         reg [3:0] idx_dt = 4'd0; // dit time array index
         reg [3:0] idx_dh = 4'd0; // dash time array index
         reg [12:0] dt_sum = 13'd256;  // global sum of all dit times
         reg [12:0] dh_sum = 13'd1536; // global sum of all dash times 
         reg [13:0] sum = 14'd1792;    // sum of both dit and dash times
         reg [9:0] count;      
         reg [4:0] dit_cnt = 5'd0;
         reg [3:0] dash_cnt = 4'd0;
         reg [3:0] i;

         ref_out = sum[13:4]; // assign ref_out sum/16
         if (load)
            begin
            // load a new Dit or Dash time into one of the arrays and
            // compute new ref time
            if (dashdit)
               // DASH time
               begin
               dit_cnt = 5'd0; // clear consecutive dit counter 
               if (dash_cnt < 7)
                  // if consecutive dash_cnt<7 then increment dash_cnt
                  dash_cnt = dash_cnt + 1; 
               count = lst_count;  // get current count from input
               // subtract old dash count value from dash count sum
               dh_sum = dh_sum - dh_time[idx_dh];
               // add new count value to global dash sum  
               dh_sum = dh_sum + count;
               // place new value in dash count array
               dh_time[idx_dh] = count;
               // circular dash time buffer
               // (set dash count index to next position in buffer)
               if (idx_dh == 7)
                  idx_dh = 0;
               else 
                  idx_dh = idx_dh + 1; 
               end
            else
               // DIT time
               begin
               dash_cnt = 4'd0; // clear consecutive dash counter
               // if conscutive dit_cnt < 15 then increment dit_cnt
               // otherwise freeze the count at 15
               if (dit_cnt < 15)
                  dit_cnt = dit_cnt + 1;
               // get current count from input
               count = lst_count;
               // subtract old dit count value from dit count sum
               dt_sum = dt_sum - dt_time[idx_dt];
               // add new count value to global dit sum
               dt_sum = dt_sum + count;
               // place new value in dit count array
               dt_time[idx_dt] = count;
               // circular dit time buffer
               // (set dit count index to next position)
               if (idx_dt == 7)
                  idx_dt = 0;
               else 
                  idx_dt = idx_dt + 1;
               end
            if (dit_cnt == 15)
               begin
               // if too many dits in a row and no dashes reduce
               // all dash times in dh_time array by a factor of 1/2
               for(i=0;i<=7;i=i+1)
                  dh_time[i] = (dh_time[i]>>1);
               // reset dit_cnt but start from 8 this time
               // if too many dashes in a row and no dits
               dh_sum = (dh_sum>>1);    
               dit_cnt = 8;
               end
            else
               begin
               // if too many dashes in a row and no dits
               // increase all dash times by a factor of two  
               if (dash_cnt == 7)
                  begin
                  for(i=0;i<=7;i=i+1)
                     dh_time[i] = dh_time[i]*2;
                  dh_sum = dh_sum*2;
                  // reset dash_cnt but start from 4 this time
                  dash_cnt = 4;
                  end 
               sum = dt_sum + dh_sum;
               ref_out = sum[13:4]; // assign ref_out sum/16
               end
            end
      end
 
endmodule   

