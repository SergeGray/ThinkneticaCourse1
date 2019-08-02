class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :passenger
  end

  def attach_wagon(wagon)
    return false unless wagon.passenger?
    super
  end
end

