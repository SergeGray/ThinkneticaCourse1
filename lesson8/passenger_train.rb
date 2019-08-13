class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :passenger
  end

  def attach_wagon(wagon)
    wagon.passenger? ? super : false
  end
end

