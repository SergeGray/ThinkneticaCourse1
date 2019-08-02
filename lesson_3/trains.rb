class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def receive_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end
end

class Route
  attr_reader :stations

  def initialize(start, *stations, destination)
    @start = start
    @destination = destination
    @stations = [@start] + stations + [@destination]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    trains_on_route = station.trains.select { |train| train.route == self }
    #Don't delete the station if trains on it have this route assigned
    return false if station == @start || station == @stop
    return false unless trains_on_route.empty?
    @stations.delete(station)
  end
end

class Train
  attr_reader :type, :wagons, :speed, :route

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
  end

  def increase_speed(by)
    @speed += by
  end

  def stop
    @speed = 0
  end

  def attach_wagon
    @wagons += 1 if self.speed == 0
  end

  def detach_wagon
    @wagons -= 1 if self.speed == 0
  end

  def assign_route(route)
    @route = route
    @route.stations.first.receive_train(self)
  end

  def current_station
    @route.stations.find { |station| station.trains.include?(self) }   
  end

  def previous_station
    @route.stations[@route.stations.index(current_station) - 1]
  end

  def next_station
    @route.stations[@route.stations.index(current_station) + 1]
  end

  def move_forward
    destination = next_station
    #Methods rely on a train being at a station, so using a variable
    return false if destination.nil?
    current_station.send_train(self)
    destination.receive_train(self)
  end

  def move_back
    destination = previous_station
    #Ditto
    return false if destination == @route.stations.last
    current_station.send_train(self)
    destination.receive_train(self)
  end
end
