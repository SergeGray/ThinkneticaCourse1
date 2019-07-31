arr = [0, 1]
fib = 1
while fib < 100
  arr << fib
  fib += arr[-2]
end
puts arr
