class Route
  include InstanceCounter
  include Validator

  attr_reader :stations

  def initialize(*stations)
    @start, *@stations, @destination = stations
    validate!
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    trains_on_route = station.trains.select { |train| train.route == self }
    return false if station == @start || station == @stop
    return false unless trains_on_route.empty?
    @stations.delete(station)
  end

  private

  def validate!
    raise ArgumentError, 'Недостаточно станций' unless @destination
    raise ArgumentError, 'Повторяющиеся станции' if @stations.uniq!
    raise ArgumentError, 'Неверные номера станций' if @stations.compact!
  end
end

