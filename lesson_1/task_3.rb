puts "Введите значения трёх сторон треугольника: "

sides = Array.new(3).map { gets.to_i }

#Getting side values for right triangle check
cat1, cat2, hyp = sides.sort

qualities = []

if sides.uniq.size == 1  #Equilateral check
  qualities << "равнобедренный" << "равносторонний" 
else
  if hyp**2 == cat1**2 + cat2**2  #Right check
    qualities << "прямоугольный"
  end
  if sides.uniq.size != sides.size  #Isosceles check
    qualities << "равнобедренный"
  end
end

qualities << "без особых качеств" if qualities.empty?

puts "Треугольник #{qualities.join(", ")}."
