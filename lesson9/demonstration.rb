# frozen_string_literal: true

require_relative 'require_all'

valid_objects = {
  Station => ['station'],
  CargoTrain => ['123-aa'],
  Route => [Station.new('station'), Station.new('station2')],
  CargoWagon => [1200.0]
}

invalid_objects = {
  Station => ['f'],
  PassengerTrain => ['Vladimir'],
  Route => [Station.new('station3')],
  PassengerWagon => [76.5]
}

puts '4 Valid Objects'
valid_objects.each do |obj_class, params|
  obj = obj_class.new(*params)
  puts obj.valid?
end

puts '4 Invalid Objects'
invalid_objects.each do |obj_class, params|
  obj_class.new(*params)
rescue ArgumentError => e
  puts e.message
end

puts 'Accessor history'
wagon = CargoWagon.new(900.0)
wagon.company = 'RZhD'
puts wagon.company
wagon.company = 'Indian Railways'
puts wagon.company
p wagon.company_history

puts 'Strong accessor'
class Strong
  extend Accessors

  strong_attr_accessor :person, String
end

strong = Strong.new
strong.person = 'Serge'
puts strong.person
begin
  strong.person = 420
rescue ArgumentError => e
  puts e.message
end
