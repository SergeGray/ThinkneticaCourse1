# frozen_string_literal: true

module StationInterface
  private

  def station_create
    print 'Введите название станции: '
    name = gets.chomp
    @stations << Station.new(name)
    puts "Станция #{name} создана."
  rescue ArgumentError => e
    puts "При создании станции возникла ошибка: #{e.message}."
    retry
  end

  def stations_with_index
    @stations.each_with_index.map do |station, index|
      "#{index}: #{station.name}"
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

  def station_select
    puts 'Выберите станцию:'
    puts stations_with_index
    station = @stations[gets.to_i]

    puts 'Неверная станция.' unless station
    station
  end
end
