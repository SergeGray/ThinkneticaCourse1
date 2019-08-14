# frozen_string_literal: true

module StationMenu
  STATION_OPTIONS = %i[
    main
    station_create
    station_actions
  ].freeze
  STATION_ACTIONS = %i[
    main
    view_trains
    view_passenger_trains
    view_cargo_trains
  ].freeze
  OPTIONS_STR = [
    '1. Создать станцию',
    '2. Действия со станциями',
    '0. Вернуться в главное меню'
  ].freeze
  ACTIONS_STR = [
    'Выберите действие:',
    '1. Показать все поезда',
    '2. Показать пассажирские поезда',
    '3. Показать грузовые поезда',
    '0. Вернуться в главное меню'
  ].freeze

  def main(*); end

  def station_options
    puts OPTIONS_STR
    choice = gets.to_i

    public_send(STATION_OPTIONS[choice] || :station_options)
    station_options
  end

  def station_actions(station = nil)
    station ||= station_select
    return unless station

    puts ACTIONS_STR
    choice = gets.to_i

    public_send(STATION_ACTIONS[choice] || :station_actions, station)
    station_actions(station)
  end
end
