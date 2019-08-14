# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations
  validate :start, :presence
  validate :destination, :presence

  def initialize(*stations)
    @start, *@stations, @destination = stations
    validate!
    extra_validate!
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    trains_on_route = station.trains.select { |train| train.route == self }
    return false if [@start, @stop].include?(station)
    return false unless trains_on_route.empty?

    @stations.delete(station)
  end

  private

  def extra_validate!
    raise ArgumentError, 'Повторяющиеся станции' if @stations.uniq!
    raise ArgumentError, 'Неверные номера станций' if @stations.compact!
  end
end
