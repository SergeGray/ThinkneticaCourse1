def discriminant(a, b, c)
  # Discriminant formula
  b**2 - 4 * a * c
end

def root(a, b, d)
  # Root formula
  c = Math.sqrt(d)
  if c == 0
    (-b/(2 * a))
  else
    # The root uses same variable as the discriminant in the formula
    [c, -c].map { |x| (-b + x)/(2 * a) }  
  end
end

puts "Введите коэффициенты a, b и c: "

a, b, c = Array.new(3).map { gets.to_f }

d = discriminant(a, b, c)

print "D = #{d}, "
if d < 0
  puts "Корней нет."
else 
  x = root(a, b, d)
  if d == 0
    puts "Один корень: #{x}."
  else
    puts "Два корня: #{x.join(", ")}."
  end
end
