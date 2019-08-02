def triangle_area(base, height)
  # Triangle area formula
  base * height / 2
end

print "Введите основание: "
a = gets.to_i

print "Введите высоту: "
h = gets.to_i

puts "Площадь треугольника - #{triangle_area(a, h)}."
