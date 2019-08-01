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

  def initialize(start, *stops, destination)
    @start = start
    @destination = destination
    @stations = [@start] + stops + [@destination]
  end

  def add_stop(station)
    @stations.insert(-2, station)
  end

  def remove_stop(station)
    #Removing the station the train is at messes up the algorithm
    #But this method is required
    #Do I have to worry about it?
    return if station == @stations.first || station == @stations.last
    @stations.delete(station)
  end
end

class Train
  attr_reader :type, :wagons, :speed

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
    return if next_station.nil?
    current_station.send_train(self)
    destination.receive_train(self)
  end

  def move_back
    destination = previous_station
    #Ditto
    return if previous_station == @route.stations.last
    current_station.send_train(self)
    destination.receive_train(self)
  end
end
