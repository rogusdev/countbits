require 'json'

times = {}

MAXBITS = 31
#BOT = -2147483648
#TOP = 2147483647
BOT = -147483648
TOP = 147483647

START = Time.now
times[:start] = 0

b = Array.new(MAXBITS) { |i| 1 << i }

# https://stackoverflow.com/questions/1414951/how-do-i-get-elapsed-time-in-milliseconds-in-ruby
def elapsed_ms
  ((Time.now - START) * 1000.0).to_i
end

times[:array] = elapsed_ms

File.open('counts.bin', 'wb') do |f|
  BOT.upto TOP do |j|

    times[j.to_s] = elapsed_ms if (j % 10000000) == 0
    c = j < 0 ? 1 : 0
    MAXBITS.times { |i| c += (j & b[i]) >> i }
    f.write c.chr
  end

  # last positive int is for sure MAXBITS on bits
  #  we have to do this out of loop or else int rolls around and becomes infinite loop!
  f.write MAXBITS.chr
end

times[:end] = elapsed_ms
times[:average] = (times[:end] - times[:array]) / (times.count - 3)

puts times.to_json

