class CargoWagon < Wagon
  def initialize(capacity)
    @type = :cargo
    super(capacity)
  end
  
  def load(volume)
    @occupied += volume
    @available -= volume
  end
end

