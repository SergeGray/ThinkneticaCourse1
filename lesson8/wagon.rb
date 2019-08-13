class Wagon
  include Manufacturer

  attr_reader :available, :occupied

  def initialize(capacity)
    @capacity = capacity
    @occupied = 0
    @available = @capacity
  end

  def cargo?
    @type == :cargo
  end

  def passenger?
    @type == :passenger
  end
end

