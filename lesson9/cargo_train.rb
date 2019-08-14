# frozen_string_literal: true

class CargoTrain < Train
  attr_reader :type
  validate :number, :presence
  validate :number, :format, FORMAT
  validate :number, :type, String

  def initialize(number)
    super
    @type = :cargo
  end

  def attach_wagon(wagon)
    wagon.cargo? ? super : false
  end
end
