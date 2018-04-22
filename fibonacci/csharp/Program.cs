// time dotnet run 42  # this is slower than running the built dll!

// dotnet new console -f netcoreapp2.0 -n Fibonacci

using System;

namespace Fibonacci
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(args[0]);
            Console.WriteLine(n.ToString());

            DateTime start = DateTime.UtcNow;
            Console.WriteLine(RecursiveFibonacci(n).ToString());
            Console.WriteLine(DateTime.UtcNow.Subtract(start).TotalMilliseconds);
        }

        private static int RecursiveFibonacci(int n)
        {
            return n < 1 ? 0 : n == 1 ? 1 : RecursiveFibonacci(n - 1) + RecursiveFibonacci(n - 2);
        }
    }
}
