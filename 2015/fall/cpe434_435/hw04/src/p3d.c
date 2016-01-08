#include <stdio.h>

int main ()
{
	FILE *fp;
	char data;
	int index, retval;

	fp = fopen("p3c.bin","rb");
	if (!fp)
	{
		printf("\nUnable to open file, error.");
		return 1;
	}

	for (index = 0; index < 32; index++)
	{
		retval = fread(&data, sizeof(char), 1, fp);
		if (retval == 0)
		{
			printf("\nRead byte %d. Contents: NULL.", index);
		} else {
			printf("\nRead byte %d. Contents: %d.", index, (int)data);
		}
	}

	fclose(fp);
	return 0;
}
