class CargoTrain < Train
  def initialize(number)
    super
    @type = :cargo
  end

  def attach_wagon(wagon)
    return false unless wagon.cargo?
    super
  end
end

