<?php

// about 3 minutes per 10 million numbers, estimate around 20 hours for all 4+ billion, creating 4 gb file lookup table
//  somehow, different size VMs made almost no difference at all: smallest RSC, 2nd biggest RSC, EC2 c1.xlarge...

class CountBits
{
	// must be less than 126 to be a positive int in a byte!
	//  max bits should be ONE less than the actual size, for shifting negative ints
	const MAXBITS = 31;
//	const BOT = -2147483648;
//	const TOP = 2147483647;
	const BOT = -147483648;
	const TOP = 147483647;

	private $bits;
	public $times = array();

    private $start;

	private function elapsedMs()
	{
		return (int)((microtime(true) - $this->start) * 1000);
	}

	private function fillBits ()
	{
		$this->bits = array();
		for ($i = 0; $i < self::MAXBITS; $i++)
		 { $this->bits[$i] = 1 << $i; }
	}

	public function __construct ()
    {
		$this->start = microtime(true);
		$this->times["start"] = $this->elapsedMs();
		$this->fillBits();
		$this->times["array"] = $this->elapsedMs();
    }

	public function writeCounts ()
	{
		$f = fopen('counts.bin', 'w');
		$this->times["file"] = $this->elapsedMs();

		for ($j = self::BOT; $j < self::TOP; $j++)
		{
			if (($j % 10000000) == 0) { $this->times[(string)$j] = $this->elapsedMs(); }
			$c = $j < 0 ? 1 : 0;
			for ($i = 0; $i < self::MAXBITS; $i++)
//		 	 { $c += (($j & $this->bits[$i]) == $this->bits[$i] ? 1 : 0); }
		 	 { $c += ($j & $this->bits[$i]) >> $i; }
			fwrite($f, chr($c));
		}

		// last positive int is for sure MAXBITS on bits
		//  we have to do this out of loop or else int rolls around and becomes infinite loop!
		fwrite($f, chr(self::MAXBITS));
		fclose($f);

		$this->times["end"] = $this->elapsedMs();
		$this->times["average"] = (int)(($this->times["end"] - $this->times["array"]) / (count($this->times) - 4));
	}
}

$cb = new CountBits();
$cb->writeCounts();

echo json_encode($cb->times);

?>

