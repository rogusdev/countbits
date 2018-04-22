
import java.lang.System;

public class Fibonacci
{
    public static void main(String[] args)
    {
        int n = Integer.parseInt(args[0]);
        System.out.println(n);

        long start = System.nanoTime();
        System.out.println(recursiveFibonacci(n));
        System.out.println((System.nanoTime() - start) / 1000000);
    }

    private static int recursiveFibonacci(int n)
    {
        return n < 1 ? 0 : n == 1 ? 1 : recursiveFibonacci(n - 1) + recursiveFibonacci(n - 2);
    }
}
