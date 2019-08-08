class Station
  include InstanceCounter

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
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

