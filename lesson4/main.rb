require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'

class ControlPanel
  def initialize 
    @stations = []
    @trains = []
    @routes = []
  end

  def main
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
        @stations << Station.new(name)
        puts "\nСтанция #{name} создана."

      when 2
        puts "\nВыберите тип поезда:\n\n"\
             "1. Пассажирский\n\n"\
             "2. Грузовой\n\n"
        type_choice = gets.to_i

        unless (1..2).include?(type_choice)
          puts "\nНеверный тип поезда."
          next
        end

        print "\nВведите номер поезда: "
        number = gets.to_i

        case type_choice
        when 1
          @trains << PassengerTrain.new(number)
        when 2
          @trains << CargoTrain.new(number)
        else
          puts "\nНеверный тип поезда. "
          next
        end

        puts "\nПоезд №#{number} создан."

      when 3
        puts "\nВведите номера станций в маршруте по порядку через пробел"\
             "(минимум 2)"
        puts stations_with_index
        route_array = gets.chomp.split.map(&:to_i)
        stations = route_array.map do |index|
          @stations[index]
        end
        stations.compact!

        if stations.length < 2
          puts "\nНедостаточно стаций в маршруте."
          next
        end

        @routes << Route.new(*stations)
        puts "\nМаршрут создан."

      when 4
        puts "\nВыберите станцию:"
        puts stations_with_index
        station = @stations[gets.to_i]

        unless station
          puts "\nНеверная станция."
          next
        end

        puts "\nВыберите действие:\n\n"\
             "1. Показать все поезда\n\n"\
             "2. Показать пассажирские поезда\n\n"\
             "3. Показать грузовые поезда\n\n"
        action_choice = gets.to_i

        unless (1..3).include?(action_choice)
          puts "\nНеверное действие."
          next
        end

        case action_choice
        when 1 then puts view_trains(station)
        when 2 then puts view_trains_by_type(station, :passenger)
        when 3 then puts view_trains_by_type(station, :cargo)
        end

      when 5
        puts "\nВыберите поезд:"
        puts trains_with_index
        train = @trains[gets.to_i]

        unless train
          puts "\nНеверный поезд."
          next
        end

        puts "Выберите действие:\n\n"\
             "1. Прикрепить пассажирский вагон\n\n"\
             "2. Прикрепить товарный вагон\n\n"\
             "3. Отцепить последний вагон\n\n"\
             "4. Назначить маршрут\n\n"\
             "5. Двигаться вперёд\n\n"\
             "6. Двигаться назад\n\n"
        action_choice = gets.to_i

        unless (1..6).include?(action_choice)
          puts "\nНеверное действие."
          next
        end

        case action_choice
        when 1
          unless train.attach_wagon(PassengerWagon.new)
            puts "\nНевозможно прикрепить вагон. "\
                 "Возможно неверный тип поезда, либо ненулевая скорость."
          else
            puts "\nВагон прикреплён."
          end

        when 2
          unless train.attach_wagon(CargoWagon.new)
            puts "\nНевозможно прикрепить вагон. "\
                 "Возможно неверный тип поезда, либо ненулевая скорость."
          else
            puts "\nВагон прикреплён."
          end

        when 3
          train.detach_wagon
          puts "\nВагон отцелен."

        when 4
          puts "\nВыберите маршрут:"
          puts routes_with_index
          route = @routes[gets.to_i]

          unless route
            puts "\nНеверный маршрут."
            next
          end

          train.assign_route(route)
          puts "Маршрут назначен."

        when 5
          unless train.move_forward
            puts "\nПоезд уже достиг конца маршрута."
          else
            puts "\nПоезд проехал на следующую станцию."
          end

        when 6
          unless train.move_back
            puts "\nПоезд не может двигаться назад."
          else
            puts "\nПоезд вернулся на предыдущую станцию."
          end

        end

      when 6
        puts "\nВыберите маршрут:"
        puts routes_with_index
        route = @routes[gets.to_i]

        unless route
          puts "\nНеверный маршрут."
          next
        end

        puts "\nВыберите действие:\n\n"\
             "1. Добавить станцию\n\n"\
             "2. Удалить станцию (кроме первой и последней)\n\n"
        action_choice = gets.to_i

        unless (1..2).include?(action_choice)
          puts "\nНеверное действие."
          next
        end

        puts "\nВыберите станцию:"

        case action_choice
        when 1
          puts stations_with_index
          station = @stations[gets.to_i]

          unless station
            puts "\nНеверная станция."
            next
          end

          route.add_station(station)
          puts "\nСтанция #{station.name} добавлена."

        when 2
          route.stations.each_with_index do |station, index|
            puts "\n#{index}: #{station.name}\n"
          end   
          station = route.stations[gets.to_i]

          unless station
            puts "\nНеверная станция."
            next
          end

          route.remove_station(station)
          puts "\nСтанция #{station.name} удалена."
        end
      end
    end
  end

  private

  def stations_with_index
    @stations.each_with_index.map do |station, index|
      "\n#{index}: #{station.name}\n"
    end
  end

  def trains_with_index
    @trains.each_with_index.map do |train, index|
      "\n#{index}: #{train.number}\n"
    end
  end

  def routes_with_index
    @routes.each_with_index.map do |route, index|
      "\n#{index}: #{route.stations.map(&:name).join(", ")}\n"
    end
  end

  def view_trains(station)
    station.trains.map do |train|
      train.number
    end
  end
  
  def view_trains_by_type(station, type)
    station.trains_by_type(type).map do |train|
      train.number
    end
  end
end

control_panel = ControlPanel.new

control_panel.main




