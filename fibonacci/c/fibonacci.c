
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

int elapsed_ms(struct timeval start)
{
	struct timeval now;
	gettimeofday(&now, NULL);
    return (now.tv_sec - start.tv_sec) * 1000 + (now.tv_usec - start.tv_usec) / 1000;
}

int recursiveFibonacci(int n)
{
	return n < 1 ? 0 : n == 1 ? 1 : recursiveFibonacci(n - 1) + recursiveFibonacci(n - 2);
}

int main(int argc, char **argv)
{
	// http://blockofcodes.blogspot.com/2013/07/how-to-convert-string-to-integer-in-c.html
	int n = atoi(argv[1]);
	printf("%d\n", n);

	// http://www.cplusplus.com/reference/clibrary/ctime/ctime/
	// https://stackoverflow.com/questions/10192903/time-in-milliseconds
	struct timeval start;
	gettimeofday(&start, NULL);

	printf("%d\n", recursiveFibonacci(n));
	printf("%d\n", elapsed_ms(start));

	return 0;
}
