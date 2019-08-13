class CargoTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :cargo
  end

  def attach_wagon(wagon)
    return false unless wagon.cargo?
    super
  end
end

