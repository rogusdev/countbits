
// mcs countbits.cs && chmod 755 countbits.exe && ./countbits.exe
// about 1-2 second per 10 million numbers, around 9 minutes for all 4+ billion, creating 4 gb file lookup table



using System;
using System.IO;

class CountBits
{
	// must be less than 126 to be a positive int in a byte!
	//  max bits should be ONE less than the actual size, for shifting negative ints
	private const int MAXBITS = 31;
	private static int[] b = new int[MAXBITS];

	public static void Main ()
	{
		Console.WriteLine(DateTime.Now.ToString("r"));

		for (int i = 0; i < MAXBITS; i++) { b[i] = 1 << i; }

		Console.WriteLine(DateTime.Now.ToString("r"));

		BinaryWriter f = new BinaryWriter(File.Open("counts.bin", FileMode.Create));

		byte c;
		for (int j = -2147483648; j < 2147483647; j++)
		{
if ((j % 10000000) == 0) { Console.WriteLine(j + ": " + DateTime.Now.ToString("r")); }
			c = (byte)(j < 0 ? 1 : 0);
			for (int i = 0; i < MAXBITS; i++)
			 { c += (byte)((j & b[i]) >> i); }
			f.Write(c);
		}

		// last positive int is for sure MAXBITS on bits
		//  we have to do this out of loop or else int rolls around and becomes infinite loop!
		f.Write((byte)MAXBITS);

		f.Close();
		Console.WriteLine(DateTime.Now.ToString("r"));
	}
}
