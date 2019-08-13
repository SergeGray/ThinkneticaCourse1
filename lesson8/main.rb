# frozen_string_literal: true

require_relative 'require_all'

class ControlPanel
  include StationMenu
  include TrainMenu
  include RouteMenu
  include StationInterface
  include TrainInterface
  include RouteInterface

  MAIN_MENU = %i[
    abort
    station_options
    train_options
    route_options
  ].freeze
  MENU_STR = [
    '1. Станции',
    '2. Поезда',
    '3. Маршруты',
    '0. Выйти из программы'
  ].freeze

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def main(*)
    puts MENU_STR.join("\n")
    choice = gets.to_i
    send(MAIN_MENU[choice] || :main)
    main
  end
end
