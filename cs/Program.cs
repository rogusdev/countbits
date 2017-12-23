
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using Newtonsoft.Json;

namespace CountBits
{
    class Program
    {
        // must be less than 126 to be a positive int in a byte!
        //  max bits should be ONE less than the actual size, for shifting negative ints
        private const int MAXBITS = 31;
        private static int[] b = new int[MAXBITS];

        //private const int BOT = -2147483648;
        //private const int TOP = 2147483647;
        private const int BOT = -147483648;
        private const int TOP = 147483647;

        static void Main(string[] args)
        {
            var times = new Dictionary<string, long>();
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            times["start"] = stopwatch.ElapsedMilliseconds;

            for (int i = 0; i < MAXBITS; i++) { b[i] = 1 << i; }

            times["array"] = stopwatch.ElapsedMilliseconds;

            BinaryWriter f = new BinaryWriter(File.Open("counts.bin", FileMode.Create));

            times["file"] = stopwatch.ElapsedMilliseconds;

            byte c;
            for (int j = BOT; j < TOP; j++)
            {
                if ((j % 10000000) == 0) { times[j.ToString()] = stopwatch.ElapsedMilliseconds; }
                c = (byte)(j < 0 ? 1 : 0);
                for (int i = 0; i < MAXBITS; i++)
                 { c += (byte)((j & b[i]) >> i); }
                f.Write(c);
            }

            // last positive int is for sure MAXBITS on bits
            //  we have to do this out of loop or else int rolls around and becomes infinite loop!
            f.Write((byte)MAXBITS);

            f.Close();
            times["end"] = stopwatch.ElapsedMilliseconds;
            times["average"] = (times["end"] - times["file"]) / (times.Count - 4);

            stopwatch.Stop();

            Console.WriteLine(JsonConvert.SerializeObject(times));
        }
    }
}

