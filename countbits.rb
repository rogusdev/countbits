
# ruby1.8 countbits.rb
# 9 min 1-3 sec per 10 million in my virtualbox image

# ruby1.9.1 countbits.rb
# 2 min ~32 sec per 10 million in my virtualbox image

# jruby countbits.rb # jruby 1.5.1
# 1 min 35-45 sec per 10 million in my virtualbox image


MAXBITS = 31

puts Time.now

b = Array.new(MAXBITS) {|i| 1 << i }

puts Time.now

File.open('counts.bin', 'wb') do |f|
	-2147483648.upto 2147483647 do |j|

puts j.to_s + ": " + Time.now.to_s if (j % 10000000) == 0
		c = j < 0 ? 1 : 0
		MAXBITS.times {|i| c += (j & b[i]) >> i }
		f.write c.chr
	end

	# last positive int is for sure MAXBITS on bits
	#  we have to do this out of loop or else int rolls around and becomes infinite loop!
	f.write MAXBITS.chr
end

puts Time.now


