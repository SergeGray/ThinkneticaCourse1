shopping_cart = {}

while true
  puts "Введите название товара или стоп, чтобы завершить работу."
  entry = gets.chomp
  break if entry == "стоп"
  puts "Введите цену товара:"
  price = gets.to_f
  puts "Введите количество товара:"
  amount = gets.to_i
  shopping_cart[entry] = { price: price, amount: amount }
end

total_price = 0
shopping_cart.each do |k, v|
  entry_price = v.values.reduce(&:*)
  total_price += entry_price
  puts "#{k}: #{v}, Цена: #{"%.2f" % entry_price}."
end

puts "\nОбщая цена: #{"%.2f" % total_price}."
