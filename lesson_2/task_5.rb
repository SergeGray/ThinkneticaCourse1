months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
puts "Введите число, месяц, год"
day, month, year = Array.new(3).map { gets.to_i }

if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
  #Add 1 day to febuary if it's a leap year
  months[1] += 1
end

#Actual formula
puts months.take(month-1).sum + day
 
