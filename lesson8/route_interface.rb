# frozen_string_literal: true

module RouteInterface
  def route_create
    puts 'Введите номера станций в маршруте по порядку через пробел'\
         '(минимум 2)'
    puts stations_with_index
    route_array = gets.chomp.split.map(&:to_i)
    stations = route_array.map { |index| @stations[index] }
    @routes << Route.new(*stations)
    puts 'Маршрут создан.'
  rescue ArgumentError => e
    puts "При создании маршрута возникла ошибка: #{e.message}."
    retry
  end

  def route_select
    puts 'Выберите маршрут:'
    puts routes_with_index
    route = @routes[gets.to_i]

    puts 'Неверный маршрут.' unless route
    route
  end

  def add_station(route)
    station = station_select

    if route.stations.include?(station)
      puts 'Станция уже есть в маршруте.'
    elsif station
      route.add_station(station)
      puts "Станция #{station.name} добавлена."
    else
      puts 'Неверная станция.'
    end
  end

  def remove_station(route)
    route.stations[1...-1].each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end
    station = route.stations[1...-1][gets.to_i]

    if station
      route.remove_station(station)
      puts "Станция #{station.name} удалена."
    else
      puts 'Неверная станция.'
    end
  end

  private

  def routes_with_index
    @routes.each_with_index.map do |route, index|
      "#{index}: #{route.stations.map(&:name).join(', ')}"
    end
  end
end
