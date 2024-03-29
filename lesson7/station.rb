class Station
  include InstanceCounter
  include Validator

  attr_reader :trains, :name

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
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

  def each_train
    @trains.each { |train| yield(train) }
  end

  private

  def validate!
    raise ArgumentError, 'Слишком короткое название' if @name.length < 4
  end
end

