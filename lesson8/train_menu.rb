# frozen_string_literal: true

module TrainMenu
  TRAIN_OPTIONS = %i[
    main
    train_create
    train_actions
  ].freeze
  TRAIN_ACTIONS = %i[
    main
    attach_passenger
    attach_cargo
    detach_wagon
    all_wagons
    assign_route
    forward
    backward
  ].freeze
  OPTIONS_STR = [
    '1. Создать поезд',
    '2. Действия с поездами',
    '0. Вернуться в главное меню'
  ].freeze
  ACTIONS_STR = [
    'Выберите действие:',
    '1. Прикрепить пассажирский вагон',
    '2. Прикрепить товарный вагон',
    '3. Отцепить последний вагон',
    '4. Показать все вагоны',
    '5. Назначить маршрут',
    '6. Двигаться вперёд',
    '7. Двигаться назад',
    '0. Вернуться в главное меню'
  ].freeze

  def main(*); end

  private

  def train_options
    puts OPTIONS_STR.join("\n")
    choice = gets.to_i
    send(TRAIN_OPTIONS[choice] || :train_options)
    train_options
  end

  def train_actions(train = nil)
    train ||= train_select
    return unless train

    puts ACTIONS_STR.join("\n")
    choice = gets.to_i
    send(TRAIN_ACTIONS[choice] || :train_actions, train)
    train_actions(train)
  end
end
