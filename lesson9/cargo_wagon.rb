# frozen_string_literal: true

class CargoWagon < Wagon
  include Validation

  validate :capacity, :type, Float

  def initialize(capacity)
    @type = :cargo
    super
  end

  def load(volume)
    @occupied += volume
    @available -= volume
  end
end
