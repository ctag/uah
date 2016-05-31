#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

struct station {
	int success;
	int collision;
	int slot;
};

const double quanta = 51.2; // Slot duration in micro seconds

/**
 * rmNewline
 * Strips the ending '\n' char from an array
 */
void rmNewline (char * string)
{
	// Variables
	short unsigned int index;
	index = 0;

	// Iterate through char array until end
	while (string[index] != '\n' && string[index] != '\0')
	{
		index++;
	}
	string[index] = '\0';
}

/**
 * readNum
 * Reads the next int of a file
 * where numbers are line separated.
 */
int readNum (FILE * fp)
{
	char buff[32];		// character buffer
	int val;
	fgets(buff, 32, fp);
	val = atoi(buff);
	return val;
}

void printStation (struct station current, int number)
{
	printf("Station: %d. Collision: %d. Success: %d. Slot: %d.\n", number, current.collision, current.success, current.slot);
}

int main(int argc, char * argv[])
{
    FILE *fp; 			// File pointer to random number list
    int num_stations; 	// total count of stations
    int success_count; 	// main() success tracker
    int slot; 			// The current slot
    int iterations; 	// For part 2
    float success_avg; 	// For part 2
    int totes_rand; 	// random number pulled from file
    struct station * stationlist;

    // Check command line args & initialization
    if (argc == 3 || argc == 4)
	{
		num_stations = atoi(argv[1]);
        fp = fopen(argv[2], "r");
        if (fp == NULL)
		{
			perror("File failed to open.\n");
		}
		success_count = 0;
		slot = 0;
		iterations = 1; // the default
		success_avg = 0;
        stationlist = (struct station*)malloc(sizeof(struct station) * num_stations);
        for (int i = 0; i < num_stations; i++)
		{
			stationlist[i] = (struct station){0, 0, 0};
		}
		printf("Number of stations: %d\n", num_stations);
	}
	else
	{
		fprintf(stderr, "usage: program <station count> <rand file> [iterations]\n");
		exit(1);
	}

	if (argc == 4)
	{
		iterations = atoi(argv[3]);
	}

	for (int iteration = 0; iteration < iterations; iteration++)
	{
		bool first_success = true;
		// Loop until all stations successfully send
		while (success_count < num_stations)
		{
			printf("\nLoop %d at %.2fus\n", slot, (slot*quanta));
			int transmit = 0;

			// Count number of stations trying to transmit
			for (int i = 0; i < num_stations; i++)
			{
				if (stationlist[i].success >= num_stations)
				{
					break;
				}
				if (stationlist[i].slot == slot)
				{
					transmit++;
				}
			}

			if (transmit == 1) // A success!
			{
				printf("Success!\n");
				for (int i = 0; i < num_stations; i++)
				{
					if (stationlist[i].success >= num_stations)
					{
						break;
					}
					if (stationlist[i].slot == slot)
					{
						printf("Station: %d\n", i);
						stationlist[i].success++;
						success_count++;
						if (first_success)
						{
							success_avg += (slot*quanta);
							first_success = false;
						}
					}
				}
				if (argc == 4)
					break;
			}
			else if (transmit > 1) // collision
			{
				printf("Collision!\n");
				for (int i = 0; i < num_stations; i++)
				{
					if (stationlist[i].success >= num_stations)
					{
						break;
					}
					if (stationlist[i].slot == slot)
					{
						printf("Station %d, ", i);
						stationlist[i].collision++;
						totes_rand = readNum(fp);
						stationlist[i].slot += 1 + (stationlist[i].slot + (totes_rand%((int)pow((double)2, (double)stationlist[i].collision))));
						printf("next slot: %d\n", stationlist[i].slot);
					}
				}
			}
			else // no transmit
			{
				printf("No station transmission attempted.\n");
			}
			// Print all, debugging
			/*for (int i = 0; i < num_stations; i++)
			{
				printStation(stationlist[i], i);
			}*/
			slot++;
		}
		printf("\nResetting stations.\n");
		for (int i = 0; i < num_stations; i++)
		{
			stationlist[i] = (struct station){0, 0, 0};
			success_count = 0;
			slot = 0;
		}
	}

	printf("\n\nAverage time to first success: %.3f\n", (success_avg/iterations));

	// Close random number file
	fclose(fp);

    return 0;
}















