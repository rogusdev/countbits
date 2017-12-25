import json, time

# must be less than 126 to be a positive int in a byte!
#  max bits should be ONE less than the actual size, for shifting negative ints
MAXBITS = 31

#BOT = -2147483648
#TOP = 2147483647
BOT = -147483648
TOP = 147483647

times = {}

start = time.time()

def elapsed_ms():
	return int((time.time() - start) * 1000)

times["start"] = elapsed_ms()

bits = []
for i in range(MAXBITS):
	bits.append(1 << i)

times["array"] = elapsed_ms();

f = open('counts.bin', 'w')
times["file"] = elapsed_ms()

for j in range(BOT, TOP):
	if ((j % 10000000) == 0):
		times[j] = elapsed_ms()
	c = 1 if j < 0 else 0
	for i in range(MAXBITS):
		c += (j & bits[i]) >> i
	f.write(chr(c))

# last positive int is for sure MAXBITS on bits
#  we have to do this out of loop or else int rolls around and becomes infinite loop!
f.write(chr(MAXBITS))
f.close();

times["end"] = elapsed_ms();
times["average"] = (int)((times["end"] - times["array"]) / (len(times) - 4));

print(json.dumps(times));

