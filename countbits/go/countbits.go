package main

import (
	//    "encoding/binary"
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"time"
)

// must be less than 126 to be a positive int in a byte!
//  max bits should be ONE less than the actual size, for shifting negative ints
const MAXBITS = 31

//const BOT = -2147483648;
//const TOP = 2147483647;
const BOT = -147483648
const TOP = 147483647

func elapsed_ms(start time.Time) int64 {
	return int64(time.Since(start) / time.Millisecond)
}

func main() {
	// https://coderwall.com/p/cp5fya/measuring-execution-time-in-go
	// https://golang.org/pkg/time/#Now
	start := time.Now()

	//    func elapsed_ms() int64 {
	//        return time.Since(start) / time.Millisecond
	//    }

	// https://gobyexample.com/maps
	// https://tour.golang.org/basics/11
	times := make(map[string]int64)

	times["start"] = elapsed_ms(start)

	// https://gobyexample.com/arrays
	// https://medium.com/learning-the-go-programming-language/bit-hacking-with-go-e0acee258827
	//d2 := []byte{115, 111, 109, 101, 10}
	var b [MAXBITS]int
	for i := uint(0); i < MAXBITS; i++ {
		b[i] = 1 << i
	}

	times["array"] = elapsed_ms(start)

	// https://gobyexample.com/writing-files
	f, err := os.Create("counts.bin")
	if err != nil {
		panic(err)
	}
	defer f.Close()

	w := bufio.NewWriter(f)

	times["file"] = elapsed_ms(start)

	var c byte
	for j := BOT; j < TOP; j++ {
		if (j % 10000000) == 0 {
			times[strconv.Itoa(j)] = elapsed_ms(start)
		}

		if j < 0 {
			c = 1
		} else {
			c = 0
		}

		for i := uint(0); i < MAXBITS; i++ {
			c += byte((j & b[i]) >> i)
		}

		// https://stackoverflow.com/questions/16888357/convert-an-integer-to-a-byte-array
		//bs := make([]byte, 4)
		//binary.LittleEndian.PutUint32(bs, 31415926)

		_, err := w.Write([]byte{c})
		if err != nil {
			panic(err)
		}
	}

	// last positive int is for sure MAXBITS on bits
	//  we have to do this out of loop or else int rolls around and becomes infinite loop!
	w.Write([]byte{byte(MAXBITS)})
	w.Flush()

	times["end"] = elapsed_ms(start)
	times["average"] = (times["end"] - times["file"]) / int64(len(times)-4)

	// https://stackoverflow.com/questions/24652775/convert-go-map-to-json
	// https://blog.golang.org/json-and-go
	// https://golang.org/pkg/encoding/json/
	jsonBytes, _ := json.Marshal(times)
	fmt.Println(string(jsonBytes))
}
