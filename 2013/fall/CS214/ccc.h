/**
  * @description - Console Color Commands
  * By: Christopher Bero - 2011 [modified Fall 2013]
  * This lets you specify specific ascii characters to specific colors
  * 
  * Used for the infamous BattleShip LAN war of Bob Jones [BJHS].
  * Built for Windows OS.
  */

#include <windows.h>
#include <string>

/**
  * @description - Console Color Commands: setup
  */
HANDLE hConsole = GetStdHandle (STD_OUTPUT_HANDLE);
COORD hReset = {0};

/**
  * @description - Use this to set console color
  *
  * Syntax:
  * setclr(one of the corresponding numbers below);
  */
void setclr (int c) {
	SetConsoleTextAttribute
    	    (hConsole, c | FOREGROUND_INTENSITY);
}

void cls () {
	SetConsoleCursorPosition(hConsole,hReset);
}

void clslow ( void )
{
  DWORD n;                         /* Number of characters written */
  DWORD size;                      /* number of visible characters */
  COORD coord = {0};               /* Top left screen position */
  CONSOLE_SCREEN_BUFFER_INFO csbi;

  /* Get a handle to the console
  HANDLE h = GetStdHandle ( STD_OUTPUT_HANDLE ); */

  GetConsoleScreenBufferInfo ( hConsole, &csbi );

  /* Find the number of characters to overwrite */
  size = csbi.dwSize.X * csbi.dwSize.Y;

  /* Overwrite the screen buffer with whitespace */
  FillConsoleOutputCharacter ( hConsole, TEXT ( ' ' ), size, coord, &n );
  GetConsoleScreenBufferInfo ( hConsole, &csbi );
  FillConsoleOutputAttribute ( hConsole, csbi.wAttributes, size, coord, &n );

  /* Reset the cursor to the top left position */
  SetConsoleCursorPosition ( hConsole, coord );
}

/*
How to use:
SetConsoleTextAttribute
        (hConsole, FOREGROUND_RED | FOREGROUND_INTENSITY);
*/

/*
Use above funtion before an output function to set the color,
You must manually reset the color afterwards.
So, if the color is green, you set it to red, print something
then set it back to green when you're done.
*/


////////////////////////
//    Color Notes
//////////////////////
//  0	black,
//  1	dark_blue,
//  2	dark_green,
//  3	dark_cyan,
//  4	dark_red,
//  5	dark_magenta,
//  6	dark_yellow,
//  7	light_gray,
//  8	dark_gray,
//  9	light_blue,
// 10	light_green,
// 11	light_cyan,
// 12	light_red,
// 13	light_magenta,
// 14	light_yellow,
// 15	white




