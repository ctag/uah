/*
 * cs317hw1_15.c
 * 
 * Brute Force Password Generation w/ clock
 * 
 * Copyright 2014 Christopher Bero <berocs@bns-anarch>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
 
 // Requires -std=c99 and -lm flags


#include <stdio.h>
#include <math.h>
#include <time.h>


int main(int argc, char **argv)
{
	clock_t timer_clock;
	
	//printf("%d\n" , CLOCKS_PER_SEC);
	
	char alphabet[26] = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
	
	int password_len = 0;
	long unsigned int possibilities = 0;
	int alphabet_len = sizeof(alphabet) / sizeof(alphabet[0]);
	
	printf("Enter the password length: ");
	scanf("%d" , &password_len);
	
	possibilities = pow(alphabet_len, password_len);
	
	printf("\n%lu words total. Enter [y] to continue.\n" , possibilities);	
	char input;
	scanf("%d" , input); // Assumes client competence
	
	timer_clock = clock();
	printf("\nclock started\n");
	
	for (long unsigned int i = 0; i < possibilities; i++)
	{
		long unsigned int mod_val = i;
		char password[password_len];
		for (int j = 0; j < password_len; j++)
		{
			int ch = (mod_val % alphabet_len);
			password[j] = alphabet[ch];
			mod_val = mod_val / alphabet_len;
		}
		//printf("\nstring: %s" , password); // You can't do this, intereference from the shell throws off our clock.
	}
	
	timer_clock = clock() - timer_clock;
	printf("clock ended.\n");
	
	printf("It took %f seconds to generate %lu possible combinations\n\n" , ((float)timer_clock/(CLOCKS_PER_SEC)) , possibilities);
	
	return 0;
}

