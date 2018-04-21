
const fs = require('fs');
const Readable = require('stream').Readable;

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

let times = { "start": elapsedMs() };

let b = [];
for (let i = 0; i < MAXBITS; i++) { b[i] = 1 << i; }

times["array"] = elapsedMs();

let f = fs.createWriteStream("counts.bin")

times["file"] = elapsedMs();

const buf = Buffer.allocUnsafe(1);
let c, j = BOT;

// https://github.com/substack/stream-handbook
// https://nodejs.org/api/stream.html#stream_implementing_a_readable_stream
let rs = Readable();
rs._read = function () {
    if ((j % 10000000) == 0) { times[j] = elapsedMs(); }
    c = (j < 0 ? 1 : 0);
    for (let i = 0; i < MAXBITS; i++)
     { c += ((j & b[i]) >> i); }
    buf.writeUInt8(c, 0);
    rs.push(buf);

    if (j++ >= TOP) {
        // last positive int is for sure MAXBITS on bits
        //  we have to do this out of loop or else int rolls around and becomes infinite loop!
        buf.writeUInt8(MAXBITS, 0);
        rs.push(buf);
        rs.push(null);
    }
};

// https://stackoverflow.com/questions/11447872/callback-to-handle-completion-of-pipe
f.on('finish', function () {
    times["end"] = elapsedMs();

    times["average"] = Math.floor((times["end"] - times["file"]) / (Object.keys(times).length - 4));

    console.log(JSON.stringify(times));
});

rs.pipe(f);

