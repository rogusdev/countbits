
// gcc -std=c99 -o countbits.out countbits.c && ./countbits.out
// about 2-3 seconds in virtualbox ubuntu, 4-5 seconds in cygwin, per 10 million numbers, around 18 or ~35 minutes for all 4+ billion, creating 4 gb file lookup table


#include <stdio.h>
#include <time.h>

int main ()
{
	// http://www.cplusplus.com/reference/clibrary/ctime/ctime/
	time_t rawtime;
	time(&rawtime); printf("%s", ctime(&rawtime));

	// must be less than 126 to be a positive int in a byte!
	//  max bits should be ONE less than the actual size, for shifting negative ints
	const int MAXBITS = 31;

	int bits[MAXBITS];
	for (int i = 0; i < MAXBITS; i++)
	 { bits[i] = 1 << i; }

	time(&rawtime); printf("%s", ctime(&rawtime));

	// http://www.cplusplus.com/reference/clibrary/cstdio/putc/
	FILE* counts = fopen("counts.bin","wb");

	char c;
	for (int j = -2147483648; j < 2147483647; j++)
	{
if ((j % 10000000) == 0) { time(&rawtime); printf("%d: %s", j, ctime(&rawtime)); }
		c = (char)(j < 0 ? 1 : 0);
		for (int i = 0; i < MAXBITS; i++)
	 	 { c += (j & bits[i]) >> i; }
		fputc(c, counts);
	}

	// last positive int is for sure MAXBITS on bits
	//  we have to do this out of loop or else int rolls around and becomes infinite loop!
	fputc((char)MAXBITS, counts);

	fclose(counts);

	time(&rawtime); printf("%s", ctime(&rawtime));
	return 0;
}

