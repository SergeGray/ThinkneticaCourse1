class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :cargo
  end

  def attach_wagon(wagon)
    wagon.cargo? ? super : false
  end
end

