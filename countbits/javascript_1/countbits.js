
const fs = require('fs');

const MAXBITS = 31

//const BOT = -2147483648;
//const TOP = 2147483647;
const BOT = -147483648;
const TOP = 147483647;

const MS_PER_SEC = 1000;
const NS_PER_MS = 1e6;
const start = process.hrtime();

function elapsedMs() {
    // https://nodejs.org/api/process.html#process_process_hrtime_time
    let diff = process.hrtime(start);
    return Math.floor((diff[0] * MS_PER_SEC) + (diff[1] / NS_PER_MS));
}

(async() => {
  let times = { "start": elapsedMs() };

  let b = [];
  for (let i = 0; i < MAXBITS; i++) { b[i] = 1 << i; }

  times["array"] = elapsedMs();

  let f = fs.createWriteStream("counts.bin")

  times["file"] = elapsedMs();

  const buf = Buffer.allocUnsafe(1);
  let c;
  for (let j = BOT; j < TOP; j++)
  {
    if ((j % 10000000) == 0) { times[j] = elapsedMs(); }
    c = (j < 0 ? 1 : 0);
    for (let i = 0; i < MAXBITS; i++)
    { c += ((j & b[i]) >> i); }

    // FIXME: I am uncertain if this will actually write the correct data
    //  is the write async such that it might use the buffer's contents
    //  later on, after the buffer has been updated again?
    buf.writeUInt8(c, 0);
    if (!f.write(buf)) {
      // wait for the drain event that will clear the WriteStream buffer
      await new Promise(resolve => f.once('drain', resolve));
    }
  }

  // last positive int is for sure MAXBITS on bits
  //  we have to do this out of loop or else int rolls around and becomes infinite loop!
  buf.writeUInt8(MAXBITS, 0);
  f.write(buf);

  f.end();
  times["end"] = elapsedMs();

  times["average"] = Math.floor((times["end"] - times["file"]) / (Object.keys(times).length - 4));

  console.log(JSON.stringify(times));
})();
