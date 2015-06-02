-- VHDL module for binary to bcd temperature converter module
-- B. Earl Wells, ECE Department University of Alabama in Huntsville
library IEEE;
use IEEE.std_logic_1164.all;

-- Input Parameters
--     TMPIN -- 9 bit two-complement temperature value that represents 1/2 degree Celsius
--     FAR_CEL -- Fahrenheit/Celsius Output: FAR_CEL='1' Fahrenheit, FAR_CEL='0' Celsius
-- Output Parameters
--     BCD_OUT -- 8 bit BCD representation of input temperature
--     LDP -- indicates if output temperature is greater than 100 degrees F or C
--     RDP -- indicates a half C degree
-- Note: Module only works properly for positive Celsius values 
entity TEMP2BCD is
   port (TMPIN: in STD_LOGIC_VECTOR (8 downto 0);
         FAR_CEL: in STD_LOGIC;
         BCD_OUT: out STD_LOGIC_VECTOR (7 downto 0);
         LDP : out STD_LOGIC;
         RDP : out STD_LOGIC);
end TEMP2BCD;

architecture LOOKUP of TEMP2BCD is
signal BCD_CEL : STD_LOGIC_VECTOR (8 downto 0);
signal BCD_FAR : STD_LOGIC_VECTOR (8 downto 0);
begin
   RDP <=not TMPIN(0);
   with FAR_CEL select
      LDP <= BCD_FAR(8) when '0',
             BCD_CEL(8) when others;

   with FAR_CEL select
      BCD_OUT <= BCD_FAR(7 downto 0) when '0',
                 BCD_CEL(7 downto 0) when others; 

   with TMPIN(7 downto 1) select

    BCD_CEL <= "000000000"  when  "0000000",
               "000000001"  when  "0000001",
               "000000010"  when  "0000010",
               "000000011"  when  "0000011",
               "000000100"  when  "0000100",
               "000000101"  when  "0000101",
               "000000110"  when  "0000110",
               "000000111"  when  "0000111",
               "000001000"  when  "0001000",
               "000001001"  when  "0001001",
               "000010000"  when  "0001010",
               "000010001"  when  "0001011",
               "000010010"  when  "0001100",
               "000010011"  when  "0001101",
               "000010100"  when  "0001110",
               "000010101"  when  "0001111",
               "000010110"  when  "0010000",
               "000010111"  when  "0010001",
               "000011000"  when  "0010010",
               "000011001"  when  "0010011",
               "000100000"  when  "0010100",
               "000100001"  when  "0010101",
               "000100010"  when  "0010110",
               "000100011"  when  "0010111",
               "000100100"  when  "0011000",
               "000100101"  when  "0011001",
               "000100110"  when  "0011010",
               "000100111"  when  "0011011",
               "000101000"  when  "0011100",
               "000101001"  when  "0011101",
               "000110000"  when  "0011110",
               "000110001"  when  "0011111",
               "000110010"  when  "0100000",
               "000110011"  when  "0100001",
               "000110100"  when  "0100010",
               "000110101"  when  "0100011",
               "000110110"  when  "0100100",
               "000110111"  when  "0100101",
               "000111000"  when  "0100110",
               "000111001"  when  "0100111",
               "001000000"  when  "0101000",
               "001000001"  when  "0101001",
               "001000010"  when  "0101010",
               "001000011"  when  "0101011",
               "001000100"  when  "0101100",
               "001000101"  when  "0101101",
               "001000110"  when  "0101110",
               "001000111"  when  "0101111",
               "001001000"  when  "0110000",
               "001001001"  when  "0110001",
               "001010000"  when  "0110010",
               "001010001"  when  "0110011",
               "001010010"  when  "0110100",
               "001010011"  when  "0110101",
               "001010100"  when  "0110110",
               "001010101"  when  "0110111",
               "001010110"  when  "0111000",
               "001010111"  when  "0111001",
               "001011000"  when  "0111010",
               "001011001"  when  "0111011",
               "001100000"  when  "0111100",
               "001100001"  when  "0111101",
               "001100010"  when  "0111110",
               "001100011"  when  "0111111",
               "001100100"  when  "1000000",
               "001100101"  when  "1000001",
               "001100110"  when  "1000010",
               "001100111"  when  "1000011",
               "001101000"  when  "1000100",
               "001101001"  when  "1000101",
               "001110000"  when  "1000110",
               "001110001"  when  "1000111",
               "001110010"  when  "1001000",
               "001110011"  when  "1001001",
               "001110100"  when  "1001010",
               "001110101"  when  "1001011",
               "001110110"  when  "1001100",
               "001110111"  when  "1001101",
               "001111000"  when  "1001110",
               "001111001"  when  "1001111",
               "010000000"  when  "1010000",
               "010000001"  when  "1010001",
               "010000010"  when  "1010010",
               "010000011"  when  "1010011",
               "010000100"  when  "1010100",
               "010000101"  when  "1010101",
               "010000110"  when  "1010110",
               "010000111"  when  "1010111",
               "010001000"  when  "1011000",
               "010001001"  when  "1011001",
               "010010000"  when  "1011010",
               "010010001"  when  "1011011",
               "010010010"  when  "1011100",
               "010010011"  when  "1011101",
               "010010100"  when  "1011110",
               "010010101"  when  "1011111",
               "010010110"  when  "1100000",
               "010010111"  when  "1100001",
               "010011000"  when  "1100010",
               "010011001"  when  "1100011",
               "100000000"  when  "1100100",
               "100000001"  when  "1100101",
               "100000010"  when  "1100110",
               "100000011"  when  "1100111",
               "100000100"  when  "1101000",
               "100000101"  when  "1101001",
               "100000110"  when  "1101010",
               "100000111"  when  "1101011",
               "100001000"  when  "1101100",
               "100001001"  when  "1101101",
               "100010000"  when  "1101110",
               "100010001"  when  "1101111",
               "100010010"  when  "1110000",
               "100010011"  when  "1110001",
               "100010100"  when  "1110010",
               "100010101"  when  "1110011",
               "100010110"  when  "1110100",
               "100010111"  when  "1110101",
               "100011000"  when  "1110110",
               "100011001"  when  "1110111",
               "100100000"  when  "1111000",
               "100100001"  when  "1111001",
               "100100010"  when  "1111010",
               "100100011"  when  "1111011",
               "100100100"  when  "1111100",
               "100100101"  when  "1111101",
               "100100110"  when  "1111110",
               "100100111"  when  "1111111",
               "---------"  when others;


   with TMPIN(7 downto 0) select

    BCD_FAR <= "000110010"  when  "00000000",
               "000110010"  when  "00000001",
               "000110011"  when  "00000010",
               "000110100"  when  "00000011",
               "000110101"  when  "00000100",
               "000110110"  when  "00000101",
               "000110111"  when  "00000110",
               "000111000"  when  "00000111",
               "000111001"  when  "00001000",
               "001000000"  when  "00001001",
               "001000001"  when  "00001010",
               "001000001"  when  "00001011",
               "001000010"  when  "00001100",
               "001000011"  when  "00001101",
               "001000100"  when  "00001110",
               "001000101"  when  "00001111",
               "001000110"  when  "00010000",
               "001000111"  when  "00010001",
               "001001000"  when  "00010010",
               "001001001"  when  "00010011",
               "001010000"  when  "00010100",
               "001010000"  when  "00010101",
               "001010001"  when  "00010110",
               "001010010"  when  "00010111",
               "001010011"  when  "00011000",
               "001010100"  when  "00011001",
               "001010101"  when  "00011010",
               "001010110"  when  "00011011",
               "001010111"  when  "00011100",
               "001011000"  when  "00011101",
               "001011001"  when  "00011110",
               "001011001"  when  "00011111",
               "001100000"  when  "00100000",
               "001100001"  when  "00100001",
               "001100010"  when  "00100010",
               "001100011"  when  "00100011",
               "001100100"  when  "00100100",
               "001100101"  when  "00100101",
               "001100110"  when  "00100110",
               "001100111"  when  "00100111",
               "001101000"  when  "00101000",
               "001101000"  when  "00101001",
               "001101001"  when  "00101010",
               "001110000"  when  "00101011",
               "001110001"  when  "00101100",
               "001110010"  when  "00101101",
               "001110011"  when  "00101110",
               "001110100"  when  "00101111",
               "001110101"  when  "00110000",
               "001110110"  when  "00110001",
               "001110111"  when  "00110010",
               "001110111"  when  "00110011",
               "001111000"  when  "00110100",
               "001111001"  when  "00110101",
               "010000000"  when  "00110110",
               "010000001"  when  "00110111",
               "010000010"  when  "00111000",
               "010000011"  when  "00111001",
               "010000100"  when  "00111010",
               "010000101"  when  "00111011",
               "010000110"  when  "00111100",
               "010000110"  when  "00111101",
               "010000111"  when  "00111110",
               "010001000"  when  "00111111",
               "010001001"  when  "01000000",
               "010010000"  when  "01000001",
               "010010001"  when  "01000010",
               "010010010"  when  "01000011",
               "010010011"  when  "01000100",
               "010010100"  when  "01000101",
               "010010101"  when  "01000110",
               "010010101"  when  "01000111",
               "010010110"  when  "01001000",
               "010010111"  when  "01001001",
               "010011000"  when  "01001010",
               "010011001"  when  "01001011",
               "000000000"  when  "01001100",
               "100000001"  when  "01001101",
               "100000010"  when  "01001110",
               "100000011"  when  "01001111",
               "100000100"  when  "01010000",
               "100000100"  when  "01010001",
               "100000101"  when  "01010010",
               "100000110"  when  "01010011",
               "100000111"  when  "01010100",
               "100001000"  when  "01010101",
               "100001001"  when  "01010110",
               "100010000"  when  "01010111",
               "100010001"  when  "01011000",
               "100010010"  when  "01011001",
               "100010011"  when  "01011010",
               "100010011"  when  "01011011",
               "100010100"  when  "01011100",
               "100010101"  when  "01011101",
               "100010110"  when  "01011110",
               "100010111"  when  "01011111",
               "100011000"  when  "01100000",
               "100011001"  when  "01100001",
               "100100000"  when  "01100010",
               "100100001"  when  "01100011",
               "100100010"  when  "01100100",
               "100100010"  when  "01100101",
               "100100011"  when  "01100110",
               "100100100"  when  "01100111",
               "100100101"  when  "01101000",
               "100100110"  when  "01101001",
               "100100111"  when  "01101010",
               "100101000"  when  "01101011",
               "100101001"  when  "01101100",
               "100110000"  when  "01101101",
               "100110001"  when  "01101110",
               "100110001"  when  "01101111",
               "100110010"  when  "01110000",
               "100110011"  when  "01110001",
               "100110100"  when  "01110010",
               "100110101"  when  "01110011",
               "100110110"  when  "01110100",
               "100110111"  when  "01110101",
               "100111000"  when  "01110110",
               "100111001"  when  "01110111",
               "101000000"  when  "01111000",
               "101000000"  when  "01111001",
               "101000001"  when  "01111010",
               "101000010"  when  "01111011",
               "101000011"  when  "01111100",
               "101000100"  when  "01111101",
               "101000101"  when  "01111110",
               "101000110"  when  "01111111",
               "101000111"  when  "10000000",
               "101001000"  when  "10000001",
               "101001001"  when  "10000010",
               "101001001"  when  "10000011",
               "101010000"  when  "10000100",
               "101010001"  when  "10000101",
               "101010010"  when  "10000110",
               "101010011"  when  "10000111",
               "101010100"  when  "10001000",
               "101010101"  when  "10001001",
               "101010110"  when  "10001010",
               "101010111"  when  "10001011",
               "101011000"  when  "10001100",
               "101011000"  when  "10001101",
               "101011001"  when  "10001110",
               "101100000"  when  "10001111",
               "101100001"  when  "10010000",
               "101100010"  when  "10010001",
               "101100011"  when  "10010010",
               "101100100"  when  "10010011",
               "101100101"  when  "10010100",
               "101100110"  when  "10010101",
               "101100111"  when  "10010110",
               "101100111"  when  "10010111",
               "101101000"  when  "10011000",
               "101101001"  when  "10011001",
               "101110000"  when  "10011010",
               "101110001"  when  "10011011",
               "101110010"  when  "10011100",
               "101110011"  when  "10011101",
               "101110100"  when  "10011110",
               "101110101"  when  "10011111",
               "101110110"  when  "10100000",
               "101110110"  when  "10100001",
               "101110111"  when  "10100010",
               "101111000"  when  "10100011",
               "101111001"  when  "10100100",
               "110000000"  when  "10100101",
               "110000001"  when  "10100110",
               "110000010"  when  "10100111",
               "110000011"  when  "10101000",
               "110000100"  when  "10101001",
               "110000101"  when  "10101010",
               "110000101"  when  "10101011",
               "110000110"  when  "10101100",
               "110000111"  when  "10101101",
               "110001000"  when  "10101110",
               "110001001"  when  "10101111",
               "110010000"  when  "10110000",
               "110010001"  when  "10110001",
               "110010010"  when  "10110010",
               "110010011"  when  "10110011",
               "110010100"  when  "10110100",
               "110010100"  when  "10110101",
               "110010101"  when  "10110110",
               "110010110"  when  "10110111",
               "110010111"  when  "10111000",
               "110011000"  when  "10111001",
               "110011001"  when  "10111010",
               "000000000"  when  "10111011",
               "100000001"  when  "10111100",
               "100000010"  when  "10111101",
               "100000011"  when  "10111110",
               "100000011"  when  "10111111",
               "100000100"  when  "11000000",
               "100000101"  when  "11000001",
               "100000110"  when  "11000010",
               "100000111"  when  "11000011",
               "100001000"  when  "11000100",
               "100001001"  when  "11000101",
               "100010000"  when  "11000110",
               "100010001"  when  "11000111",
               "100010010"  when  "11001000",
               "100010010"  when  "11001001",
               "100010011"  when  "11001010",
               "100010100"  when  "11001011",
               "100010101"  when  "11001100",
               "100010110"  when  "11001101",
               "100010111"  when  "11001110",
               "100011000"  when  "11001111",
               "100011001"  when  "11010000",
               "100100000"  when  "11010001",
               "100100001"  when  "11010010",
               "100100001"  when  "11010011",
               "100100010"  when  "11010100",
               "100100011"  when  "11010101",
               "100100100"  when  "11010110",
               "100100101"  when  "11010111",
               "100100110"  when  "11011000",
               "100100111"  when  "11011001",
               "100101000"  when  "11011010",
               "100101001"  when  "11011011",
               "100110000"  when  "11011100",
               "100110000"  when  "11011101",
               "100110001"  when  "11011110",
               "100110010"  when  "11011111",
               "100110011"  when  "11100000",
               "100110100"  when  "11100001",
               "100110101"  when  "11100010",
               "100110110"  when  "11100011",
               "100110111"  when  "11100100",
               "100111000"  when  "11100101",
               "100111001"  when  "11100110",
               "100111001"  when  "11100111",
               "101000000"  when  "11101000",
               "101000001"  when  "11101001",
               "101000010"  when  "11101010",
               "101000011"  when  "11101011",
               "101000100"  when  "11101100",
               "101000101"  when  "11101101",
               "101000110"  when  "11101110",
               "101000111"  when  "11101111",
               "101001000"  when  "11110000",
               "101001000"  when  "11110001",
               "101001001"  when  "11110010",
               "101010000"  when  "11110011",
               "101010001"  when  "11110100",
               "101010010"  when  "11110101",
               "101010011"  when  "11110110",
               "101010100"  when  "11110111",
               "101010101"  when  "11111000",
               "101010110"  when  "11111001",
               "101010111"  when  "11111010",
               "101010111"  when  "11111011",
               "101011000"  when  "11111100",
               "101011001"  when  "11111101",
               "101100000"  when  "11111110",
               "101100001"  when  "11111111",
               "---------"  when others;
end LOOKUP;


-- VHDL module for clock divider
-- B. Earl Wells, ECE Department University of Alabama in Huntsville

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Input parameter
--      CLK_IN 50 MHZ input clock
-- Output parameter
--      CLK_OUT slower output clock
entity CLOCK_DIVIDE is
   PORT(
		CLK_IN		: in    STD_LOGIC;
		CLK_OUT 	: out	STD_LOGIC);
end CLOCK_DIVIDE;

architecture BEHAVIORAL of CLOCK_DIVIDE is
signal NXT_CLK : STD_LOGIC_VECTOR (6 downto 0);
begin
process (CLK_IN)
begin
   if (CLK_IN = '1') then
      NXT_CLK <= NXT_CLK + '1';
      CLK_OUT <= NXT_CLK(6);
   end if;
end process;

end BEHAVIORAL;

-- Alternative Implementation of binary to hex converter example
-- that uses array constant
library IEEE; -- allows the use of STD_LOGIC and STD_LOGIC Vectors
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity BINTOHEX is
   port(I : in STD_LOGIC_VECTOR(3 downto 0);
        O : out STD_LOGIC_VECTOR(6 downto 0));
end BINTOHEX;

architecture ARRY_IMPLEMENTATION of BINTOHEX is
   type LED is array (integer range 0 to 15) of STD_LOGIC_VECTOR(6 downto 0);
   constant HEXOUT : LED := ("1000000", "1111001", "0100100", "0110000", "0011001", "0010010", 
                              "0000010", "1111000", "0000000", "0011000", "0001000", "0000011", 
                              "1000110", "0100001", "0000110", "0001110" );
   begin
   O <= HEXOUT(conv_integer(I));

end ARRY_IMPLEMENTATION;


-- Tristate buffer component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TRBUF is
   port (
      D  : in STD_LOGIC;
      EN : in STD_LOGIC;
      O  : inout STD_LOGIC
   );
end TRBUF;

architecture BEHAVIORAL of TRBUF is
   begin
   process(D,EN)
      begin
      if (EN = '1') then
         O <= D;
      else
         O <= 'Z';
      end if;
   end process;
end BEHAVIORAL; 



-- TOP Level Design of DS 1620 Temperature Display Design
-- B. Earl Wells, October 2008

library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity lab8 is 
   port
      (
      CLK_IN  : in  STD_LOGIC;
      CLR     : in  STD_LOGIC;
      FAR_CEL : in  STD_LOGIC;
      DQ      : inout  STD_LOGIC;
      CLK_OUT : out  STD_LOGIC;
      RST     : out  STD_LOGIC;
      HEX0    : out  STD_LOGIC_VECTOR(6 downto 0);
      HEX1    : out  STD_LOGIC_VECTOR(6 downto 0);
      HEX2    : out  STD_LOGIC_VECTOR(6 downto 0);
      HEX3    : out  STD_LOGIC_VECTOR(6 downto 0)
      );
end lab8;

architecture STRUCTURAL of lab8 is 

   component CLOCK_DIVIDE
      port(CLK_IN  : in STD_LOGIC;
		   CLK_OUT : inout STD_LOGIC);
   end component;

   component TEMP2BCD
      port(FAR_CEL : in STD_LOGIC;
           TMPIN   : in STD_LOGIC_VECTOR(8 downto 0);
           LDP     : out STD_LOGIC;
           RDP     : out STD_LOGIC;
           BCD_OUT : out STD_LOGIC_VECTOR(7 downto 0));
   end component;

   component DS1620_INTERFACE
      port(CLR     : in STD_LOGIC;
           CLK_IN  : in STD_LOGIC;
           DQ_IN   : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC;
           RST     : out STD_LOGIC;
           TRI_EN  : out STD_LOGIC;
           DQ_OUT  : out STD_LOGIC;
           TEMP    : out STD_LOGIC_VECTOR(8 downto 0));
   end component;

   component bintohex
      port(I : in STD_LOGIC_VECTOR(3 downto 0);
           O : out STD_LOGIC_VECTOR(6 downto 0));
   end component;
   
   component TRBUF is
      port (
         D  : in STD_LOGIC;
         EN : in STD_LOGIC;
         O  : inout STD_LOGIC
      );
   end component;

   signal BCD_OUT    : STD_LOGIC_VECTOR(7 downto 0);
   signal DQ_OUT     : STD_LOGIC;
   signal TRI_EN     : STD_LOGIC;
   signal HX3_DRV    : STD_LOGIC;
   signal TEMP       : STD_LOGIC_VECTOR(8 downto 0);
   signal DS1620_CLR : STD_LOGIC;
   signal DS1620_CLK : STD_LOGIC;

begin 

   HEX0(0) <= '1';
   HEX0(1) <= '1';
   HEX0(2) <= '1';
   HEX0(3) <= '1';
   HEX0(4) <= '1';
   HEX0(5) <= '1';
   
   HEX3(0) <= HX3_DRV;
   HEX3(1) <= '0';
   HEX3(2) <= '0';
   HEX3(3) <= HX3_DRV;
   HEX3(4) <= HX3_DRV;
   HEX3(5) <= HX3_DRV;
   HEX3(6) <= '1';
   

   DS1620_CLR <= NOT(CLR);

   C1 : CLOCK_DIVIDE port map(CLK_IN,DS1620_CLK);

   C2 : TEMP2BCD port map (FAR_CEL,TEMP,HX3_DRV,HEX0(6),BCD_OUT);

   C3 : DS1620_INTERFACE port map (DS1620_CLR,DS1620_CLK,DQ,CLK_OUT,RST,TRI_EN,DQ_OUT,TEMP);

   C4 : TRBUF port map (DQ_OUT,TRI_EN,DQ);

   C5 : BINTOHEX port map (BCD_OUT(7 downto 4),HEX2);

   C6 : BINTOHEX port map (BCD_OUT(3 downto 0),HEX1);

end STRUCTURAL; 
