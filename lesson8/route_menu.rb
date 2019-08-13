# frozen_string_literal: true

module RouteMenu
  ROUTE_OPTIONS = %i[
    main
    route_create
    route_actions
  ].freeze
  ROUTE_ACTIONS = %i[
    main
    add_station
    remove_station
  ].freeze
  OPTIONS_STR = [
    '1. Создать маршрут',
    '2. Действия с маршрутами',
    '0. Вернуться в главное меню'
  ].freeze
  ACTIONS_STR = [
    'Выберите действие:',
    '1. Добавить станцию',
    '2. Удалить станцию (кроме первой и последней)',
    '0. Вернуться в главное меню'
  ].freeze

  def main(*); end

  def route_options
    puts OPTIONS_STR.join("\n")
    choice = gets.to_i

    public_send(ROUTE_OPTIONS[choice] || :route_options)
    route_options
  end

  def route_actions(route = nil)
    route ||= route_select
    return unless route

    puts ACTIONS_STR.join("\n")
    choice = gets.to_i

    public_send(ROUTE_ACTIONS[choice] || :route_actions, route)
    route_actions(route)
  end
end
