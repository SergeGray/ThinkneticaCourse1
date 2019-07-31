class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def how_many(type)
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
  def initialize(start, destination)
    @start = start
    @destination = destination
    @stops = []
  end

  def add_stop(station)
    @stops << station
  end

  def remove_stop(station)
    #Currently removing a stop the train is at ruins the whole thing
    @stops.delete(station)
  end

  def order
    [@start] + @stops + [@destination]
  end
end

class Train
  attr_reader :speed, :type, :wagons

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
    @route.order[0].receive_train(self)
  end

  def current_station
    @route.order.find { |station| station.trains.include? self }   
  end

  def previous_station
    near_current(-1)
  end

  def next_station
    near_current(1)
  end

  def move_up
    n = next_station
    #Methods rely on a train being at a station, so using a variable
    current_station.send_train(self)
    n.receive_train(self)
  end

  def backtrack
    p = previous_station
    #Ditto
    current_station.send_train(self)
    p.receive_train(self)
  end

  private

  def near_current(offset)
    @route.order[@route.order.index(current_station) + offset]
  end
end
