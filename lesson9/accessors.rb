# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history = "@#{name}_history".to_sym
      reader(name, var_name)
      history_writer(name, var_name, var_history)
      history(name, var_history)
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym
    reader(name, var_name)
    strong_writer(name, var_name, type)
  end

  private

  def reader(name, var_name)
    define_method(name) { instance_variable_get(var_name) }
  end

  def history_writer(name, var_name, var_history)
    define_method("#{name}=".to_sym) do |value|
      instance_variable_set(var_name, value)
      history = instance_variable_get(var_history) || []
      history << value
      instance_variable_set(var_history, history)
    end
  end

  def strong_writer(name, var_name, type)
    define_method("#{name}=".to_sym) do |value|
      raise ArgumentError, 'wrong variable class' if value.class != type

      instance_variable_set(var_name, value)
    end
  end

  def history(name, var_history)
    define_method("#{name}_history".to_sym) do
      instance_variable_get(var_history)
    end
  end
end
