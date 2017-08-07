{
	 cout << right;
     cout << "\n  =====> Current Board Status <=====\n";
     int row, col;

	 // Print out the column heading values for the board
     cout << setw(7) << "0";
     for (col = 1; col < NUM_COLS; col++)
         cout << setw(3) << col;
     cout << endl;				// terminate the column heading line

     cout << setw(7) << "-";
     for (col = 1; col < NUM_COLS; col++)
         cout << setw(3) << "---";
     cout << endl;

	 // Print out each row of the board
     for (row = 0; row < NUM_ROWS ; row++)
     {
         cout << setw(3) << row << ":";
         for (col = 0; col < NUM_COLS ; col++)
         {
		     // if the position to print out is a boat, print out
			 // a . instead.  Otherwise, print out the contents
			 // of the position
             if (board[row][col] >= '1' && board[row][col] <= '4')
                 cout << setw(3) << '.'; // hide the boat numbers
             else 
                 cout << setw(3) << board[row][col];    
         }
         cout << endl;
     }
}
