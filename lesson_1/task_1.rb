#Ideal weight coefficient
COEFFICIENT = 110

print "Введите ваше имя: "
name = gets.chomp.capitalize

print "Введите ваш рост: "
height = gets.to_i

ideal_weight = height - COEFFICIENT

if ideal_weight < 0
  puts "Ваш вес уже оптимальный." 
else
  puts "#{name}, ваш оптимальный вес - #{ideal_weight} кг."
end
