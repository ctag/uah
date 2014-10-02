/*
 * cs317hw1.c
 * 
 * Counts and sorts the things in the file
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
#include <stdio.h>

FILE *input_file;
FILE *output_file;

int main(int argc, char **argv)
{
	int c = 0;
	int input_number = 0;
	input_file = fopen("input.txt", "r");
	output_file = fopen("output.txt", "w");
	
	printf("File stream open.");
	//c = fgetc(input_file);
	while ((c = fgetc(input_file)) != EOF)
	{
		if (c == 44) // 44 = , and 32 = a space
		{
			input_number++;
			printf("\ninput_number: %i" , input_number);
		}
		
		//printf("\nC: %c", c);
	}
	
	fclose(input_file);
	input_file = fopen("input.txt", "r");
	int main_sort[input_number];
	
	for (int i = 0; i < input_number; i++)
	{
		main_sort[i] = 0;
	}
	
	int store_val = 0;
	int temp_index = 0;
	int multiplier = 10;
	
	while ((c = fgetc(input_file)) != EOF)
	{
		//printf("C: %d" , c);
		if (c < 48 || c > 57) // 44 = , and 32 = a space
		{
			main_sort[temp_index] = store_val;
			temp_index++;
			store_val = 0;
			multiplier = 10;
			printf("\nfinal: %d" , main_sort[temp_index-1]);
		} else if (store_val != 0) {
			store_val = ((multiplier*store_val) + (c-48));
		} else {
			store_val = (c-48);
		}
	}
	for (int i = 0; i < (input_number-1); i++)
	{
		for (int j = 0; j < (input_number-1-i); j++)
		{
			if (main_sort[j+1] < main_sort[j])
			{
				int tmp = main_sort[j];
				main_sort[j]=main_sort[j+1];
				main_sort[j+1]=tmp;
			}
		}
	}
	for (int i = 0; i < input_number; i++)
	{
		fprintf(output_file, "%d" , (main_sort[i]));
		if (i != (input_number-1))
		{
			fputc(44, output_file);
		}
	}
	fclose(input_file);
	return 0;
}
