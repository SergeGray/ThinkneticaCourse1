# frozen_string_literal: true

class PassengerTrain < Train
  attr_reader :type
  validate :number, :presence
  validate :number, :format, FORMAT
  validate :number, :type, String

  def initialize(number)
    super
    @type = :passenger
  end

  def attach_wagon(wagon)
    wagon.passenger? ? super : false
  end
end
