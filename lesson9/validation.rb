# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(var_name, validation, param = nil)
      validations = (
        instance_variable_get(:@validations) || Hash.new do |hash, key|
          hash[key] = {}
        end
      )
      validations[var_name].merge!("valid_#{validation}".to_sym => param)
      instance_variable_set(:@validations, validations)
    end
  end

  module InstanceMethods
    def validate!
      validations = self.class.instance_variable_get(:@validations) || {}
      validations.each do |var_name, validation|
        validation.each do |command, param|
          send command, var_name, param
        end          
      end
    end

    def valid?
      validate!
      true
    rescue ArgumentError
      false
    end

    private

    def variable(name)
      instance_variable_get("@#{name}".to_sym)
    end

    def valid_presence(var_name, _)
      raise ArgumentError, "@#{var_name} is nil" unless variable(var_name)
    end

    def valid_format(var_name, regex)
      if variable(var_name) !~ regex
        raise ArgumentError, "@#{var_name} doesn't match the format"
      end
    end

    def valid_type(var_name, match_class)
      if variable(var_name).class != match_class
        raise ArgumentError, "wrong variable @#{var_name} class"
      end
    end
  end
end
