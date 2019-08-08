class Wagon
  include Manufacturer

  def cargo?
    @type == :cargo
  end

  def passenger?
    @type == :passenger
  end
end

