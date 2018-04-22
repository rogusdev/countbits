
#include <json.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

int elapsed_ms(struct timeval start)
{
	struct timeval now;
	gettimeofday(&now, NULL);
    return (now.tv_sec - start.tv_sec) * 1000 + (now.tv_usec - start.tv_usec) / 1000;
}

// https://stackoverflow.com/questions/8257714/how-to-convert-an-int-to-string-in-c
char* itoa(int num)
{
	int length = snprintf(NULL, 0, "%d", num);
	char* str = malloc(length + 1 );
	snprintf(str, length + 1, "%d", num);
	return str;
}

int main ()
{
	// http://www.cplusplus.com/reference/clibrary/ctime/ctime/
	// https://stackoverflow.com/questions/10192903/time-in-milliseconds
	struct timeval start;
	gettimeofday(&start, NULL);

	// https://gist.github.com/alan-mushi/19546a0e2c6bd4e059fd
	struct json_object *jobj;
	jobj = json_object_new_object();
	json_object_object_add(jobj, "start", json_object_new_int(elapsed_ms(start)));

	// must be less than 126 to be a positive int in a byte!
	//  max bits should be ONE less than the actual size, for shifting negative ints
	const int MAXBITS = 31;

//	const int BOT = -2147483648;
//	const int TOP = 2147483647;
	const int BOT = -147483648;
	const int TOP = 147483647;

	int bits[MAXBITS];
	for (int i = 0; i < MAXBITS; i++)
	 { bits[i] = 1 << i; }

	json_object_object_add(jobj, "array", json_object_new_int(elapsed_ms(start)));

	// http://www.cplusplus.com/reference/clibrary/cstdio/putc/
	FILE* counts = fopen("counts.bin","wb");

	int file_ms = elapsed_ms(start);
	json_object_object_add(jobj, "file", json_object_new_int(file_ms));

	int times_count = 0;
	char c;
	for (int j = BOT; j < TOP; j++)
	{
		if ((j % 10000000) == 0) {
			// FIXME: I'm not sure if json_object_put will free my memory for these keys or not...
			json_object_object_add(jobj, itoa(j), json_object_new_int(elapsed_ms(start)));
			times_count++;
		}
		c = (char)(j < 0 ? 1 : 0);
		for (int i = 0; i < MAXBITS; i++)
	 	 { c += (j & bits[i]) >> i; }
		fputc(c, counts);
	}

	// last positive int is for sure MAXBITS on bits
	//  we have to do this out of loop or else int rolls around and becomes infinite loop!
	fputc((char)MAXBITS, counts);

	fclose(counts);

	int end_ms = elapsed_ms(start);
	json_object_object_add(jobj, "end", json_object_new_int(end_ms));

	json_object_object_add(jobj, "average", json_object_new_int((end_ms - file_ms) / times_count));

	printf("%s", json_object_to_json_string(jobj));
	json_object_put(jobj);  // clean up

	return 0;
}
