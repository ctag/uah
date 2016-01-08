#include <stdio.h>

int main ()
{
	FILE *fp;
	char data;
	int index;

	fp = fopen("p3c.bin","r+b");
	if (!fp)
	{
		printf("\nUnable to open file, error.");
		return 1;
	}

	fseek(fp, 1000000, SEEK_SET);

	for (index = 100; index < 115; index++)
	{
		data = (char)index;
		fwrite(&data, sizeof(char), 1, fp);
	}

	fclose(fp);
	return 0;
}
