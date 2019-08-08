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
    return false if station == @start || station == @stop
    return false unless trains_on_route.empty?
    @stations.delete(station)
  end
end

