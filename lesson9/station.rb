# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation

  attr_reader :trains, :name
  validate :name, :format, /.{4,}/

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

  def send_to(train, station)
    station.receive_train(send_train(train))
  end

  def each_train
    @trains.each { |train| yield(train) }
  end
end
