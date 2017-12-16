require 'json'

times = {}

MAXBITS = 31
#BOT = -2147483648
#TOP = 2147483647
BOT = -147483648
TOP = 147483647

times[:start] = Time.now

b = Array.new(MAXBITS) { |i| 1 << i }

times[:array] = Time.now

File.open('counts.bin', 'wb') do |f|
  BOT.upto TOP do |j|

    times[j] = Time.now if (j % 10000000) == 0
    c = j < 0 ? 1 : 0
    MAXBITS.times { |i| c += (j & b[i]) >> i }
    f.write c.chr
  end

  # last positive int is for sure MAXBITS on bits
  #  we have to do this out of loop or else int rolls around and becomes infinite loop!
  f.write MAXBITS.chr
end

times[:end] = Time.now
times[:avg] = (times[:end] - times[:array]).to_i / (times.count - 3)

puts times.to_json

