#!/usr/bin/env ruby

def recursive_fibonacci(n)
  if n < 1
    0
  elsif n == 1
    1
  else
    recursive_fibonacci(n - 1) + recursive_fibonacci(n - 2)
  end
end

n = ARGV[0].to_i
puts n

start = Time.now.to_f
puts recursive_fibonacci(n)
puts ((Time.now.to_f - start) * 1000).to_i
