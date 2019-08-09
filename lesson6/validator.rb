module Validator
  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end

  private

  def validate!
  end
end

