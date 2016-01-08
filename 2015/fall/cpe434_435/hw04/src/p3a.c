#include <stdio.h>

int main ()
{
	FILE *fp;
	char data;
	int index;
	
	fp = fopen("p3a.bin","wb");
	if (!fp)
	{
		printf("\nUnable to open file, error.");
		return 1;
	}

	printf("Char size: %d", sizeof(char));

	for (index = 0; index < 15; index++)
	{
		data = (char)index;
		fwrite(&data, sizeof(char), 1, fp);
	}

	fclose(fp);
	return 0;
}
