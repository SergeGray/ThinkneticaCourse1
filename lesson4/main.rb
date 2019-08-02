require_relative 'control_panel'

control_panel = ControlPanel.new

#delete this later
control_panel.create_station("bob")
control_panel.create_station("sid")
control_panel.create_passenger_train(12345)
control_panel.create_cargo_train(54321)

loop do
  puts "\nВыберите действие:\n\n"\
       "1: Создать станцию\n\n"\
       "2: Создать поезд\n\n"\
       "3: Создать маршрут\n\n"\
       "4: Дейтсвия со станциями\n\n"\
       "5: Действия с поездами\n\n"\
       "6: Действия с маршрутами\n\n"\
       "0: Выйти из программы\n\n"
  choice = gets.to_i
  case choice
  when 0 then break
  when 1
    print "\nВведите название станции: "
    name = gets.chomp
    control_panel.create_station(name)
    puts "\nСтанция #{name} создана."
  when 2
    puts "\nВыберите тип поезда:\n\n"\
         "1. Пассажирский\n\n"\
         "2. Грузовой\n\n"
    type_choice = gets.to_i
    unless [1, 2].include? type_choice
      puts "\nНеверный тип поезда."
      next
    end
    print "\nВведите номер поезда: "
    number = gets.to_i
    case type_choice
    when 1
      control_panel.create_passenger_train(number)
    when 2
      control_panel.create_cargo_train(number)
    end
    puts "\nПоезд №#{number} создан."
  when 3
    puts "\nВведите номера станций в маршруте по порядку через пробел"\
         "(минимум 2)"
    puts control_panel.stations_with_index
    route_array = gets.chomp.split.map(&:to_i) 
    stations = route_array.map do |index|
      control_panel.stations[index]
    end
    stations.compact!
    if stations.length < 2
      puts "\nНедостаточно стаций в маршруте."
      next
    end
    control_panel.create_route(*stations)
    puts "\nМаршрут создан."
  when 4
    puts "\nВыберите станцию:"
    puts control_panel.stations_with_index
    station = control_panel.stations[gets.to_i]
    unless station
      puts "\nНеверная станция."
      next
    end
    puts "\nВыберите действие:\n\n"\
         "1. Показать все поезда\n\n"\
         "2. Показать пассажирские поезда\n\n"\
         "3. Показать грузовые поезда\n\n"
    action_choice = gets.to_i
    unless [1, 2, 3].include? action_choice
      puts "\nНеверное действие."
      next
    end
    case action_choice
    when 1 then puts control_panel.view_trains(station)
    when 2 then puts control_panel.view_trains_by_type(station, :passenger)
    when 3 then puts control_panel.view_trains_by_type(station, :cargo)
    end
  when 5
    puts "\nВыберите маршрут:"
    puts control_panel.routes_with_index
    route = control_panel.routes[gets.to_i]
    unless route
      puts "\nНеверный маршрут."
      next
    end
    puts "\nВыберите действие:\n\n"\
         "1. Добавить станцию\n\n"\
         "2. Удалить станцию (кроме первой и последней).\n\n"
    action_choice = gets.to_i
    unless [1, 2].include? action_choice
      puts "\nНеверное действие."
      next
    end
    puts "\nВыберите станцию:" 
    case action_choice
    when 1
      puts control_panel.stations_with_index
      station = control_panel.stations[gets.to_i]
      unless station
        puts "\nНеверная станция."
        next
      end
      control_panel.add_station(route, station)
      puts "\nСтанция #{station.name} добавлена."
    when 2
      puts route.stations.each_with_index.map do |station, index|
        "#{index}: #{station.name}"
      end
      station = route.stations[gets.to_i]
      unless station
        puts "\nНеверная станция."
        next
      end
      control_panel.remove_station(route, station)
      puts "\nСтанция #{station.name} удалена."
    end
      
  end
end


