<?php

// about 3 minutes per 10 million numbers, estimate around 20 hours for all 4+ billion, creating 4 gb file lookup table
//  somehow, different size VMs made almost no difference at all: smallest RSC, 2nd biggest RSC, EC2 c1.xlarge...

class CountBits
{
	// must be less than 126 to be a positive int in a byte!
	//  max bits should be ONE less than the actual size, for shifting negative ints
	const MAXBITS = 31;
	private static $bits;

	public static function fillBits ()
	{
		self::$bits = array();
		for ($i = 0; $i < self::MAXBITS; $i++)
		 { self::$bits[$i] = 1 << $i; }
	}

	public function __construct () { self::fillBits(); }

	public static function writeCounts ()
	{
//var_dump(self::$bits);
		$fp = fopen('counts.bin', 'w');
		for ($j = -2147483648; $j < 2147483647; $j++)
		{
if (($j % 10000000) == 0) { echo "$j: ".date('r')."\n"; }
			$c = $j < 0 ? 1 : 0;
			for ($i = 0; $i < self::MAXBITS; $i++)
//		 	 { $c += (($j & self::$bits[$i]) == self::$bits[$i] ? 1 : 0); }
		 	 { $c += ($j & self::$bits[$i]) >> $i; }
			fwrite($fp, chr($c));
		}

		// last positive int is for sure MAXBITS on bits
		//  we have to do this out of loop or else int rolls around and becomes infinite loop!
		fwrite($fp, chr(self::MAXBITS));

		fclose($fp);
	}
}

echo date('r')."\n";
$cb = new CountBits();
echo date('r')."\n";
$cb::writeCounts();
echo date('r')."\n";

?>
