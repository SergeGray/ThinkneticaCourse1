require_relative 'route'
require_relative 'station'
require_relative 'train'
require_relative 'wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'

class ControlPanel
  attr_reader :stations, :trains, :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def create_station(name)
    @stations << Station.new(name)
  end
  
  def create_passenger_train(number)
    @trains << PassengerTrain.new(number)
  end

  def create_cargo_train(number)
    @trains << CargoTrain.new(number)
  end

  def create_route(start, *stations, destination)
    @routes << Route.new(start, *stations, destination)
  end

  def add_station(route, station)
    route.add_station(station)
  end

  def remove_station(route, station)
    route.remove_station(station)
  end

  def assign_route(train, route)
    train.assign_route(route)
  end
  
  def attach_passenger_wagon(train)
    train.attach_wagon(PassengerWagon.new)
  end

  def attach_cargo_wagon(train)
    train.attach_wagon(CargoWagon.new)
  end

  def detach_wagon(train)
    train.detach_wagon
  end

  def send_train(train)
    train.move_forward
  end

  def return_train(train)
    train.move_back
  end

  def stations_with_index
    @stations.each_with_index.map do |station, index|
      "\n#{index}: #{station.name}\n"
    end
  end

  def routes_with_index
    @routes.each_with_index.map do |route, index|
      "\n#{index}: #{route.stations.join(", ")}\n"
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

