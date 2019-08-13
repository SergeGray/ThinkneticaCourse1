# frozen_string_literal: true

require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validator'
require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'

class ControlPanel
  MAIN_MENU = %i[
    abort
    station_options
    train_options
    route_options
  ]
  STATION_OPTIONS = %i[
    main
    station_create
    station_actions
  ]
  TRAIN_OPTIONS = %i[
    main
    train_create
    train_actions
  ]
  ROUTE_OPTIONS = %i[
    main
    route_create
    route_actions
  ]
  STATION_ACTIONS = %i[
    main
    view_trains
    view_trains_by_type
    view_trains_by_type
  ]
  TRAIN_ACTIONS = %i[
    main
    attach_passenger
    attach_cargo
    detach_wagon
    all_wagons
    assign_route
    forward
    backward
  ]
  ROUTE_ACTIONS = %i[
    main
    add_station
    remove_station
  ]

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def main(*)
    puts '1. Станции'
    puts '2. Поезда'
    puts '3. Маршруты'
    puts '0. Выйти из программы'
    choice = gets.to_i

    send(MAIN_MENU[choice] || :main)
    main
  end

  private

  def station_options
    puts '1. Создать станцию'
    puts '2. Действия со станциями'
    puts '0. Вернуться в главное меню'
    choice = gets.to_i

    send(STATION_OPTIONS[choice] || :station_options)
    station_options
  end

  def train_options
    puts '1. Создать поезд'
    puts '2. Действия с поездами'
    puts '0. Вернуться в главное меню'
    choice = gets.to_i

    send(TRAIN_OPTIONS[choice] || :train_options)
    train_options
  end

  def route_options
    puts '1. Создать маршрут'
    puts '2. Действия с маршрутами'
    puts '0. Вернуться в главное меню'
    choice = gets.to_i

    send(ROUTE_OPTIONS[choice] || :route_options)
    route_options
  end

  def station_actions(station = nil)
    station ||= station_select
    return unless station

    puts 'Выберите действие:'
    puts '1. Показать все поезда'
    puts '2. Показать пассажирские поезда'
    puts '3. Показать грузовые поезда'
    puts '0. Вернуться в главное меню'
    choice = gets.to_i

    send(STATION_ACTIONS[choice] || :station_actions, station)
    station_actions(station)
  end

  def train_actions(train = nil)
    train ||= train_select
    return unless train

    puts 'Выберите действие:'
    puts '1. Прикрепить пассажирский вагон'
    puts '2. Прикрепить товарный вагон'
    puts '3. Отцепить последний вагон'
    puts '4. Показать все вагоны'
    puts '5. Назначить маршрут'
    puts '6. Двигаться вперёд'
    puts '7. Двигаться назад'
    puts '0. Вернуться в главное меню'
    choice = gets.to_i

    send(TRAIN_ACTIONS[choice] || :train_actions, train)
    train_actions(train)
  end

  def route_actions(route = nil)
    route ||= route_select
    return unless route

    puts 'Выберите действие:'
    puts '1. Добавить станцию'
    puts '2. Удалить станцию (кроме первой и последней)'
    puts '0. Вернуться в главное меню'
    choice = gets.to_i

    send(ROUTE_ACTIONS[choice] || :route_actions, route)
    route_actions(route)
  end

  def station_create
    print 'Введите название станции: '
    name = gets.chomp
    @stations << Station.new(name)
    puts "Станция #{name} создана."
  rescue ArgumentError => e
    puts "При создании станции возникла ошибка: #{e.message}."
    retry
  end

  def train_create
    print 'Введите номер поезда: '
    number = gets.chomp
    choose_type(number)
  rescue ArgumentError => e
    puts "При создании поезда возникла ошибка: #{e.message}."
    retry
  end

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

  def stations_with_index
    @stations.each_with_index.map do |station, index|
      "#{index}: #{station.name}"
    end
  end

  def trains_with_index
    @trains.each_with_index.map do |train, index|
      "#{index}: #{train.number}"
    end
  end

  def routes_with_index
    @routes.each_with_index.map do |route, index|
      "#{index}: #{route.stations.map(&:name).join(', ')}"
    end
  end

  def view_trains(station)
    station.trains.map do |train|
      "#{train.number}: #{train.cargo? ? 'грузовой' : 'пассажирский'}, "\
      "#{train.wagons.length} вагонов"
    end
  end

  def view_passenger_trains(station)
    view_trains_by_type(station, :passenger)
  end

  def view_cargo_trains(station)
    view_trains_by_type(station, :cargo)
  end

  def view_trains_by_type(station, type)
    station.trains_by_type(type).map do |train|
      "#{train.number}: #{train.wagons.length} вагонов"
    end
  end

  def choose_type(number)
    puts 'Выберите тип поезда:'
    puts '1. Пассажирский'
    puts '2. Грузовой'
    choice = gets.to_i
    type = { 1 => :passenger, 2 => :cargo }[choice]
    @trains << PassengerTrain.new(number) if type == :passenger
    @trains << CargoTrain.new(number) if type == :cargo
    puts type ? "Поезд №#{number} создан." : 'Неверный тип поезда'
  end

  def attach_passenger(train)
    puts 'Укажите количество мест в вагоне'
    capacity = gets.to_i
    try_attach_wagon(train, PassengerWagon.new(capacity))
  end

  def attach_cargo(train)
    puts 'Укажите грузовой объём вагона'
    capacity = gets.to_f
    try_attach_wagon(train, CargoWagon.new(capacity))
  end

  def try_attach_wagon(train, wagon)
    if train.attach_wagon(wagon)
      puts 'Вагон прикреплён.'
    else
      puts 'Невозможно прикрепить вагон. '\
           'Возможно неверный тип поезда, либо ненулевая скорость.'
    end
  end

  def detach_wagon(train)
    train.detach_wagon
    puts 'Вагон отцелен.'
  end

  def all_wagons(train)
    train.each_wagon do |wagon|
      if wagon.cargo?
        puts "Грузовой вагон, свободный объём: #{wagon.available}, "\
             "занятый объём: #{wagon.occupied}"
      else
        puts "Пассажирский вагон, свободных мест: #{wagon.available}, "\
             "занятых мест: #{wagon.occupied}"
      end
    end
  end

  def assign_route(train)
    puts 'Выберите маршрут:'
    route = route_select
    if route
      train.assign_route(route)
      puts 'Маршрут назначен.'
    else
      puts 'Неверный маршрут.'
    end
  end

  def foward(train)
    if train.move_forward
      puts 'Поезд проехал на следующую станцию.'
    else
      puts 'Поезд уже достиг конца маршрута.'
    end
  end

  def backward(train)
    if train.move_back
      puts 'Поезд вернулся на предыдущую станцию.'
    else
      puts 'Поезд не может двигаться назад.'
    end
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

  def station_select
    puts 'Выберите станцию:'
    puts stations_with_index
    station = @stations[gets.to_i]

    puts 'Неверная станция.' unless station
    station
  end

  def route_select
    puts 'Выберите маршрут:'
    puts routes_with_index
    route = @routes[gets.to_i]

    puts 'Неверный маршрут.' unless route
    route
  end

  def train_select
    puts 'Выберите поезд:'
    puts trains_with_index
    train = @trains[gets.to_i]

    puts 'Неверный поезд.' unless train
    train
  end
end
