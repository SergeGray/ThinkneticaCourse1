class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :wagons, :speed, :route

  @@trains = {}

  def self.find(number)
    @@trains[number] || false
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @@trains[number] = self
    register_instance
  end

  def cargo?
    @type == :cargo
  end

  def passenger?
    @type == :passenger
  end

  def increase_speed(by)
    @speed += by
  end

  def stop
    @speed = 0
  end

  def attach_wagon(wagon)
    @wagons << wagon if self.speed == 0
  end

  def detach_wagon
    @wagons.pop if self.speed == 0
  end

  def assign_route(route)
    @route = route
    @route.stations.first.receive_train(self)
  end

  def move_forward
    destination = next_station
    return false unless destination
    current_station.send_train(self)
    destination.receive_train(self)
  end

  def move_back
    destination = previous_station
    return false if destination == @route.stations.last
    current_station.send_train(self)
    destination.receive_train(self)
  end

  private

  def current_station
    @route.stations.find { |station| station.trains.include?(self) }   
  end

  def previous_station
    @route.stations[@route.stations.index(current_station) - 1]
  end

  def next_station
    @route.stations[@route.stations.index(current_station) + 1]
  end
end

