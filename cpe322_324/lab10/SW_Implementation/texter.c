// Minimal hardware texter.c module used with the NIOS implementation of
// the single button texter design from Lab 10.
// Uses Bit Banging Methodology
// B. Earl Wells -- UAHuntsville, April 2015

// memory map locations of the four ports that are present -- note the
// volatile designator needed to insure that the compiler would not
// optimize out time dependent memory locations.
#define HEXLEDS      (volatile unsigned short int *) 0x000010
#define LCD          (volatile unsigned short int *) 0x000020
#define KEY               (volatile unsigned char *) 0x000030
#define LEDG                  (unsigned short int *) 0x000040

// this function is used to allow a visual indication to occur when
// one holds the the input key for a long period of time in order to backspace
// over a character
void out_ledg(unsigned char sw) {
   unsigned char ledg;
   unsigned short int input_val;                                  
   if (!sw) ledg = 0xff;         // if switch is low turn on all
   else ledg = 0;                // LEDGS to high else turn them
   *LEDG = ledg;                 // to logic zeros
}

// this function inputs a 8 bit binary number and outputs two sets of seven segment
// LED driving signals necessary to display the number in hex. 
// The labeling of the segments is LSB to MSB segment a of LS LED to segment g of MS LED
unsigned short int bintohex(unsigned char bin_num) {
   unsigned char xref[16] = {0x40,0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x00,0x18,0x08,0x03,0x46,0x21,0x06,0x0e};
   unsigned char num_h,num_l;
   unsigned int led_out;
   num_h = bin_num/16;           // get MS 4-bits of input
   num_l = bin_num - num_h*16;   // get LS 4-bits of input 
   led_out = xref[num_h]*128;     // place MS 7 segment values in upper part of integer
   led_out += xref[num_l];        // place LS 7 segment values in lower part of integer
   return led_out;                // return the integer
}

// This function estimates the speed in words per minute and sends it to
// the selected pair of seven segment LEDs
void speed_io(unsigned short int num_in) {
   unsigned short int num_bin,numi,numf,numo;
   unsigned char bcd_out;

   num_bin = 1665/num_in;   // this is the WPM estimate in binary
   numi = num_bin/10;       // this converts the binary to BCD
   numo = numi*10;          // using standard integer
   numf = num_bin-numo;     // operations present in C
   bcd_out = numi*16+numf;
   *HEXLEDS = bintohex(bcd_out); // output this value on the 7-seg Hex displays
}
// This function provides the necessary delay that is needed when initializing the
// LCD module (it is also used in the main routine for a callobrated delay while
// waiting for the key to be pressed or released
void delay(unsigned int end_count) {
   unsigned int i;
   char ch;
   volatile char * dummy;
   for (i=0;i<end_count;i++) {
      ch = *dummy;
   }
}

// this function implements the LCD write protocol
// -- it writes a byte to the LCD
#define RS_MASK  ((unsigned short int) 0x0400)
#define EN_MASK  ((unsigned short int) 0x0100)

void lcd_write (char rs, char data) {
   unsigned short int port_tmp = 0x1800;


   // *LCD bit order MSB to LSB lcdon||lcdblon||rs||rw||en||data[7..0]
   
   // apply RS and R/W signals to LCD
   if (rs) port_tmp = (port_tmp|RS_MASK); // apply rs
   *LCD = port_tmp;
   delay(7);

   // apply EN and Data
   port_tmp = (port_tmp^EN_MASK);           // apply EN 
   port_tmp += (unsigned short int) data;   // apply data
   *LCD = port_tmp;
   delay(7);

   // negate EN
   port_tmp = (port_tmp^EN_MASK);           // negate EN 
   *LCD = port_tmp;
   delay(1);
   *LCD = 0x1c00;
}

// this function initializes the LCD display for
// two row output
void lcd_init(void) {

   // wait at least 15 ms 
   delay(31250);

   // set interface for 8 bits
   lcd_write(0,0x30);

   // wait at least 4.1 ms 
   delay(10416);

   // again set interface for 8 bits
   lcd_write(0,0x30);

   // wait at least 100 us
   delay(3416);

   // again set interface for 8 bits
   lcd_write(0,0x30);

    // wait at least 100 us
   delay(3416);

   // set the display again for 8 bits but with 2 lines with font 5x8 dots
   lcd_write(0,0x38);

   // wait at least 100 us
   delay(3416);

   // set the display to on, with blinking cursor
   lcd_write(0,0x0f);

   // wait at least 1.58 ms
   delay(10416);

   // clear the display
   lcd_write(0,0x01);

   // wait at least 39 us 
   delay(100);

   // Asign cursor moving direction and shift enable
   lcd_write(0,0x07);

   // wait at least 4.1 ms 
   delay(3416);
 
   // reset LCD display memory pointer to 0  
   lcd_write(0,0x80);

   // wait at least 43 us 
   delay(10000);

}
// this function outputs the ascii value to the LCD
// at the current point on the display
void lcd_out(char ascii_in) {
   static unsigned char ch_addr = 0;
   unsigned char data_out;

   if (ascii_in == 8) { 
      // backspace
	   if (ch_addr != 0) {
	      ch_addr--;
	   }
	   else {
	      ch_addr=31;
	   }
   }
   else {
      // no backspace send a character to LCD

      // send character address to LCD
      if (ch_addr & 0x10) {
         data_out = 0xc0;
      }
      else {
         data_out = 0x80;
      }
      data_out += (0xf & ch_addr);
      lcd_write(0,data_out);

	  delay(100);

      // send ascii data to LCD
      lcd_write(1,ascii_in);
	  delay(50);

      // increment LCD character address
      if (ch_addr < 31) {
         ch_addr ++;
      }
	  else { 
         ch_addr = 0; // wrap back to 0 if at the end
      }
   }
}

// The Speed Tracker module produces the 9 bit binary value that represents
// the approximate time that is between the 1 unit value (associated with a dot and the
// time between sounded units in a character) and the 3 unit value
// associated with a dash or the space between two consecutive
// characters.  This unit does this by keeping track on the last
// eight time values that were interpreted as dots and the last eight
// time values that were interpreted as dits and then averaging them
// together to get a value that lies in between these two values.
// New time values are input by value using lst_count variable The reference time 
// is then returned by reference as a pointer to a short int (* ref_val).
// This value can then be used to determine how to interpret the next period of time
// that the switch is in the active or inactive position. The 
// current count time value should be placed on the lst_count input
// whenever the speed_tracker routine is called. The value of the dashdit
// input when the routine is called determines which eight element time 
// value arrays that the this timing information is placed. If the dashdit
// input is one it is placed in the internal dash memory arry, if the dashdit
// input is 0 it is placed in the dit memory arry. To minimize the execution
// time this averaging is accomplished by subracting away old items from the 
// total and then adding the new item before performing a four bit shift of
// the result effectively dividing it by 16. There are also program logic
// present to allow the tracker to recover from situations where
// all inputs are interpretted as dashes or dots. Such a situation
// can result when the speed changes too abruptly.

void speed_tracker (unsigned char dashdit, unsigned short int lst_count, 
                    unsigned short int * ref_out) {
   static unsigned short int dt_time[8]={32,32,32,32,32,32,32,32};
   static unsigned char idx_dt=0;
   static unsigned short int dh_time[8]={192,192,192,192,192,192,192,192};
   static unsigned char idx_dh = 0;
   static unsigned short int dt_sum = 256;  // global sum of all dit times
   static unsigned short int dh_sum = 1536; // global sum of all dash times 
   static unsigned short int sum = 1792;    // sum of both dit and dash times
   static unsigned short int dit_cnt = 0;   // consecutive dit count
   static unsigned short int dash_cnt = 0;  // consecutive dash count
   unsigned char i;
   
   // load a new Dit or Dash time into one of the arrays and compute new ref time
   if (dashdit) {
      // DASH time
      dit_cnt = 0; // clear consecutive dit counter 
      if (dash_cnt < 7) {
         dash_cnt++;  // if consecutive DASH_CNT < 7 then increment DASH_CNT
      }
      dh_sum -= dh_time[idx_dh];    //subtract old dash count value from dash count sum 
      dh_sum += lst_count;          // add new count value to global dash sum  
      dh_time[idx_dh] = lst_count;  // place new value in dash count array
      // circular dash time buffer
      if (idx_dh == 7) {                 
         idx_dh = 0;
      }
      else {
         idx_dh++;     // set dash count index to next position
      }
   }
   else {
      // DIT Time
      dash_cnt = 0; // clear consecutive dash counter
      if (dit_cnt < 15) {
         dit_cnt++; // if conscutive DIT_CNT < 15 then increment DIT_CNT
      }
      dt_sum -= dt_time[idx_dt];     // subtract old dit count value from dit count sum 
      dt_sum += lst_count;           // add new count value to global dit sum
      dt_time[idx_dt] = lst_count;  // place new value in dit count array
      // circular dit time buffer
      if (idx_dt == 7) {
         idx_dt = 0;
      }
      else { 
         idx_dt++;     // set dit count index to next position
      }
   }
   if (dit_cnt == 15) {
      for (i=0;i<8;i++) {
         dh_time[i] /= 2; // if too many dits in a row and no dashes
      }                   // reduce all dash times in DH_TIME array by a factor of two
      dh_sum /= 2;    
      dit_cnt = 8;        // reset DIT_CNT but start from 8 this time
   }
   else {
      if (dash_cnt == 7) { // if too many dashes in a row and no dits
         for (i=0;i<8;i++) { // increase all dash times by a factor of two  
            dh_time[i] *= 2;
         }
         dh_sum *= 2;
         dash_cnt = 4;       // reset DASH_CNT but start from 4 this time
      }
   }
   sum = dt_sum + dh_sum;;
   *ref_out = (sum>>4);
}
// function that coverts the dit/dash pattern into 8 bit ASCII encodings
// An active high on the RESET input resets the decoder -- allowing it
// to begin the interpretation of the next character.
// The main input to the routine is the dashdit variable where
// a logic 1 represents a dash (3 units of switch down) and a logic 0 
// represents a dit (one unit of the switch being pressed). The nxt_char
// is used by the routine to indicate whether a new character is being
// created or if the next dit/dash element should be associated with the
// current character. The value that is returned by reference by the variable
// ascii_out is is the ASCII value of the Morse code pattern.
// If the decoder module receives the pattern dit dit dash dash (. . _ _)
// then it toggles an internal case flag allowing the user to change from 
// upper to lower case. The function returns a logic TRUE if the current
// character after the processing of the dashdit value is a valid character
// and it returns a FALSE if it is not a valid ASCII character

#define TRUE (unsigned char) 1
#define FALSE (unsigned char) 0
unsigned char decoder (unsigned char dashdit,unsigned char nxt_char,unsigned char *ascii_out) {
   static char xref[128] = {8,0,0,0,0,0,0,0,0,36,0,0,63,0,0,0,
      0,0,0,0,0,46,0,0,0,0,0,0,0,0,39,0,0,45,0,0,0,0,0,0,
      0,0,59,0,0,40,0,0,0,0,0,44,0,0,0,0,58,0,0,0,0,0,0,0,
      53,52,0,51,0,0,0,50,0,34,0,0,0,0,0,49,54,0,47,0,0,0,41,0,
      55,0,0,0,56,0,57,48,104,118,102,0,108,0,112,106,98,120,99,121,
      122,113,0,0,115,117,114,119,100,107,103,111,105,97,110,109,101,
      116,127,0};
   static unsigned char code = 0xfe,mask = 0x7f;
   char asc; 

   if (nxt_char) {
      code = 0xfe;
      *ascii_out = 0;
   }
   else {
      code = (code << 1); 
      if (dashdit) {
         code = code | 1;
      }
      code = code & 0x7f;
      if (code == 0x63) mask = (mask ^ 0x20);
      asc = xref[code];
      if ((asc >= 'a') && (asc <= 'z')) {
         asc = (asc & mask);
      }
      *ascii_out = asc;
      if (*ascii_out) return FALSE;
      else return TRUE;
   }
   return FALSE;
}

// This is the state diagram for the main texter control module for the single button
// texter controller. Note that this section of the code utilizes nonstructured
// programming techniques that are similar to assembly language programming.
// This is not a recommend practice but EE/CPE students should be aware of the existance
// of such code and should be able to interpret it in an effective manner.

int main() 
{
   
   unsigned char sw,dashdit,space,ascii_out,dc_error;
   unsigned short int ref_count,dsh_count,lst_count;
   unsigned short int lst_count2,ref_count2,cnt_val;
  
   // initialization
   lcd_init();               // initialize LCD HW
   ref_count = 112;          // set initial dit and
   dsh_count = ref_count*3;  // dash interval count
   speed_io(ref_count);      // display initial speed in WPM

   // main loop

   // loop until key is pressed
   start:  do {
              sw=(*KEY)&1; // input switch value
	       } while (sw);

   // process next character
   nxtchar:decoder(dashdit,TRUE,&ascii_out); // reset decoder

   // get next character element (dit or dash)
   nxtunit:lst_count = 0;
 		   *LEDG = 1; // light up LEDG0
		   do {
              sw = (*KEY)&1;
	          delay(4627); // calabrated delay loop
              if (sw) goto dit; // if key is released in first 
              lst_count++;      // interval process as a dit
           } while (lst_count<ref_count);

		   // dash
		   do {
              sw = (*KEY)&1;
	          delay(4627); // calabrated delay loop
              if (sw) goto dash; // if key is released in the second
              lst_count++;       // interval process as a dash
           } while (lst_count<dsh_count);

		   // if key is held down past the dash interval then 
		   // process as a backspace
		   out_ledg(sw); // light up all 8 green LEDs

		   // wait for switch to be released
		   do {
		      sw=(*KEY)&1; // input switch value
		   } while (!sw);

		   // send backspace characters
		   out_ledg(sw); // turn off all 8 green LEDs
		   lcd_out(8); // send back space character
		   goto start;

		   // process as a dit
   dit:    dashdit=0; // clear dashdit flag
           goto ovr;

		   // process as a dash
   dash:   dashdit=1; // set dashdit flag
		   // determine new reference speed
	       speed_tracker(dashdit,lst_count,&ref_count);
		   dsh_count = ref_count*3;
		   speed_io(ref_count);  // output new speed in WPM

           // for both dit and dash send information to decoder module
   ovr:    *LEDG = 0; // turn off LEDG0
		   // ascii_out updated to reflect the current character
		   // dc_error indicates if the character is valid
		   dc_error=decoder(dashdit,FALSE,&ascii_out);

		   // sections times the period that the key is not pressed
           lst_count = 0;
		   do {
              sw = (*KEY)&1; // input switch value
		      delay(4627);   // calabrated delay loop
              if (!sw) goto endrest;      // if key is pressed in first interval
              lst_count++;                // loop back to get next unit of the
           } while (lst_count<ref_count); // current character
		   // character end
		   do {
              sw = (*KEY)&1; // input switch value
	   	      delay(4627);   // calabrated delay loop
              if (!sw) goto endchar;       // if key is pressed in second 
              lst_count++;                 // interval, output character 
           } while (lst_count<dsh_count);  // and begin processing next char

		   // If current character is a valid ASCII code
		   // then output this character and a space
		   if (!dc_error) {
		      lcd_out(ascii_out); // output character and
  		                          // space to LCD
  		      lcd_out(' ');
		   }
		   goto start;

		   // determine new speed reference then
		   // loop to obtain the next character
endrest:   speed_tracker(0,lst_count,&ref_count);
		   dsh_count = ref_count*3;
		   speed_io(ref_count);
		   goto nxtunit;

		   // output the current character if the
		   // character is a valid ASCII code
		   // begin processing next character
endchar:   if (!dc_error) {
		      lcd_out(ascii_out);
		   }
		   goto nxtchar;
}




