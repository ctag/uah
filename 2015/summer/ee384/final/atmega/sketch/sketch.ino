// DTMF (Dual Tone Multiple Frequency) Demonstration

// http://en.wikipedia.org/wiki/Dual-tone_multi-frequency

// To mix the output of the signals to output to a small speaker (i.e. 8 Ohms or higher),
// simply use 1K Ohm resistors from each output pin and tie them together at the speaker.
// Don't forget to connect the other side of the speaker to ground!

#include <Tone.h>
#include <amt1001_ino.h>

Tone colTone;
Tone rowTone;

int DTMF_cols_index;
int DTMF_rows_index;

//const int DTMF_freq1[] = { 1336, 1209, 1336, 1477, 1209, 1336, 1477, 1209, 1336, 1477 };
const int DTMF_cols[] = {1209, 1336, 1477, 1633, 1805, 1994, 2201, 2427, 2672, 2938, 3226, 3537};
const int DTMF_rows[] = {697, 770, 852, 941, 1035, 1132, 1230, 1307, 1421, 1510, 1592, 1665};

//const char DTMF_map[12][12][6] = {
//{"1", "2", "3", "A", "R", "S", "r", "s", "/", "NUL", "ERR", "ERR"},
//{"4", "5", "6", "B", "Q", "T", "q", "t", ".", "SOH", "ERR", "ERR"},
//{"7", "8", "9", "C", "P", "U", "p", "u", "-", "STX", "ERR", "ERR"},
//{"*", "0", "#", "D", "O", "V", "o", "v", "`", "ETX", "ERR", "ERR"},
//{"H", "G", "F", "E", "N", "W", "n", "w", "+", "EOT", "ERR", "ERR"},
//{"I", "J", "K", "L", "M", "X", "m", "x", ")", "ENQ", "ERR", "ERR"},
//{"d", "c", "b", "a", "Z", "Y", "l", "y", "(", "ACK", "ERR", "ERR"},
//{"e", "f", "g", "h", "I", "j", "k", "z", "'", "BEL", "ERR", "ERR"},
//{"<", ";", ":", "DEL", "~", "}", "|", "{", "&", "BS", "ERR", "ERR"},
//{"=", ">", "?", "@", "Space", "!", "?", "$", "%", "TAB", "ERR", "ERR"},
//{"DC3", "DC2", "DC1", "DLE", "SI", "SO", "CR", "FF", "VT", "LF"},
//{"DC4", "NAK", "SYN", "ETB", "CAN", "EM", "SUB", "ESC", "FS", "RS", "US", "ERR"}
//};

const char DTMF_map[10][9] = {
{'1', '2', '3', 'A', 'R', 'S', 'r', 's', '/'},
{'4', '5', '6', 'B', 'Q', 'T', 'q', 't', '.'},
{'7', '8', '9', 'C', 'P', 'U', 'p', 'u', '-'},
{'*', '0', '#', 'D', 'O', 'V', 'o', 'v', ','},
{'H', 'G', 'F', 'E', 'N', 'W', 'n', 'w', '+'},
{'I', 'J', 'K', 'L', 'M', 'X', 'm', 'x', ')'},
{'d', 'c', 'b', 'a', 'Z', 'Y', 'l', 'y', '('},
{'e', 'f', 'g', 'h', 'I', 'j', 'k', 'z', '\''},
{'<', ';', ':', '\r', '~', '}', '|', '{', '&'},
{'=', '>', '?', '@', ' ', '!', '?', '$', '%'}
};

void parseString(char input) 
{
  for (DTMF_rows_index = 0; DTMF_rows_index < 10; ++DTMF_rows_index)
  {
    for (DTMF_cols_index = 0; DTMF_cols_index < 9; ++DTMF_cols_index)
    {
      if (input == DTMF_map[DTMF_rows_index][DTMF_cols_index])
      {
        //return((rowIndex*10)+colIndex);
        return;
      }
    }
  }
}

void playDTMFE(uint8_t colIndex, uint8_t rowIndex, long duration)
{
  colTone.play(DTMF_cols[colIndex], duration);
  rowTone.play(DTMF_rows[rowIndex], duration);
}

void setup()
{
Serial.begin(9600);
colTone.begin(5);
rowTone.begin(6);
pinMode(13,OUTPUT);
}

void loop()
{
  

  uint16_t step = analogRead(A3);
    uint16_t temperature = amt1001_gettemperature(step);
    Serial.println(temperature);

  step = analogRead(A4);
    double volt = (double)step * (5.0 / 1023.0);
    uint16_t humidity = amt1001_gethumidity(volt);
    Serial.println(humidity);

  char output[] = "Temp: __. Hum: __.";
  output[6] = (temperature/10)+48;
  output[7] = (temperature%10)+48;
  output[15] = (humidity/10)+48;
  output[16] = (humidity%10)+48;

  int i;
  //int colIndex, rowIndex, retVal;
  for(i = 0; i < sizeof(output)-1; i++)
  {
    parseString(output[i]);
    //colIndex=getCol(retVal);
    //rowIndex=getRow(retVal);
    
    Serial.print(output[i]);
    Serial.print(" [");
    Serial.print(DTMF_cols[DTMF_cols_index]);
    Serial.print(", ");
    Serial.print(DTMF_rows[DTMF_rows_index]);
    Serial.print("]. ");
    
    playDTMFE(DTMF_cols_index, DTMF_rows_index, 400);
    
    digitalWrite(13, HIGH);
    delay(400);
    digitalWrite(13, LOW);
    delay(200);
  }
  

  Serial.println();
  delay(4000);
}
