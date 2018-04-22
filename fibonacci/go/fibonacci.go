package main

import (
    "os"
    "strconv"
    "fmt"
    "time"
)

func recursiveFibonacci(n int) int {
    if n < 1 {
        return 0
    } else if n == 1 {
        return 1
    } else {
        return recursiveFibonacci(n - 1) + recursiveFibonacci(n - 2);
    }
}

func main() {
    n, _ := strconv.Atoi(os.Args[1])
    fmt.Println(n)

    start := time.Now()
    fmt.Println(recursiveFibonacci(n))
    fmt.Println(int64(time.Since(start) / time.Millisecond))
}
