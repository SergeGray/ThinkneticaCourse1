# frozen_string_literal: true

module TrainInterface
  TYPE_STR = [
    'Выберите тип поезда:',
    '1. Пассажирский',
    '2. Грузовой'
  ].freeze

  private

  def train_create
    print 'Введите номер поезда: '
    number = gets.chomp
    choose_type(number)
  rescue ArgumentError => e
    puts "При создании поезда возникла ошибка: #{e.message}."
    retry
  end

  def trains_with_index
    @trains.each_with_index.map do |train, index|
      "#{index}: #{train.number}"
    end
  end

  def choose_type(number)
    puts TYPE_STR.join("\n")
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
      puts 'Поезд не может двигаться вперёд.'
    end
  end

  def backward(train)
    if train.move_back
      puts 'Поезд вернулся на предыдущую станцию.'
    else
      puts 'Поезд не может двигаться назад.'
    end
  end

  def train_select
    puts 'Выберите поезд:'
    puts trains_with_index
    train = @trains[gets.to_i]

    puts 'Неверный поезд.' unless train
    train
  end
end
