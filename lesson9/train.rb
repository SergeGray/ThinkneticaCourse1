# frozen_string_literal: true

class Train
  include Manufacturer
  include InstanceCounter
  include Validation

  FORMAT = /^[a-z|\d]{3}-?[a-z|\d]{2}$/.freeze

  attr_reader :number, :wagons, :speed, :route

  @@trains = {}

  def self.find(number)
    @@trains[number] || false
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    validate!
    unique!
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
    @wagons << wagon if @speed.zero?
  end

  def detach_wagon
    @wagons.pop if @speed.zero?
  end

  def each_wagon
    @wagons.each { |wagon| yield(wagon) }
  end

  def assign_route(route)
    current_station.send_train(self) if @route
    @route = route
    @route.stations.first.receive_train(self)
  end

  def move_forward
    return false unless @route
    return false unless next_station

    current_station.send_to(self, next_station)
  end

  def move_back
    return false unless @route
    return false if previous_station == @route.stations.last

    current_station.send_to(self, previous_station)
  end

  private

  def unique!
    found = self.class.find(@number)
    raise ArgumentError, 'Номер поезда занят' if found && found != self
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
end
