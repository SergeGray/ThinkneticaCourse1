# frozen_string_literal: true

class PassengerWagon < Wagon
  include Validation

  validate :capacity, :type, Integer

  def initialize(capacity)
    @type = :passenger
    super
  end

  def take_seat
    @occupied += 1
    @available -= 1
  end
end
