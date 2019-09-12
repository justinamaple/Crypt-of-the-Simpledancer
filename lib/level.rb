# frozen_string_literal: true

class Level
  attr_accessor :map, :turns
  attr_reader :max_x, :max_y

  def initialize
    @max_x = rand(7..9)
    @max_y = rand(7..9)
    @map = Array.new(max_x) { Array.new(max_y) }
    create_stage
  end

  def create_stage
    @turns = 0
    max_x.times do |x|
      max_y.times do |y|
        map[x][y] = if x.zero? || x == max_x - 1 || y.zero? || y == max_y - 1
                      Wall.new(x, y)
                    else
                      '-'
                    end
      end
    end
  end

  # String concat is super slow!!! Should refactor
  def to_s
    board_string = "\n"
    # Need to print top -> down
    max_y.times do |y|
      inverse_y = max_y - 1 - y
      max_x.times do |x|
        unit = map[x][inverse_y]
        if unit.class == String
          spaced_unit = ' ' + unit
          color_unit = disco_floor(x, y, spaced_unit)
        elsif unit.class == Player
          if emoji?(unit.symbol)
            color_unit = unit.symbol
          else
            color_unit = ' ' + unit.symbol
          end
        else
          color_unit = unit_color(unit)
          color_unit = ' ' + color_unit unless emoji?(color_unit)
        end
        board_string += color_unit
      end
      board_string += "\n"
    end
    board_string += "\n"
    board_string
  end

  def disco_floor(x, y, unit)
    if turns.even?
      if x.odd? && y.odd?
        unit.colorize(:light_magenta)
      elsif x.even? && y.odd?
        unit.colorize(:light_cyan)
      elsif x.odd? && y.even?
        unit.colorize(:light_cyan)
      else # x.even? && y.even?
        unit.colorize(:light_magenta)
      end
    else # turn.odd?
      if x.odd? && y.odd?
        unit.colorize(:light_cyan)
      elsif x.even? && y.odd?
        unit.colorize(:light_magenta)
      elsif x.odd? && y.even?
        unit.colorize(:light_magenta)
      else # x.even? && y.even?
        unit.colorize(:light_cyan)
      end
    end
  end

  def unit_color(unit)
    case unit
    when Wall
      unit.to_s.colorize(color: :light_black)
    when GreenSlime
      unit.to_s.colorize(:green)
    when OrangeSlime
      unit.to_s.colorize(:light_red)
    when BlueSlime
      unit.to_s.colorize(:light_blue)
    when Zombie
      unit.to_s.colorize(:light_yellow)
    when BlueBat
      unit.to_s.colorize(:blue)
    end
  end

  def emoji?(unit)
    unit.match?(Unicode::Emoji::REGEX)
  end

  def player?(x, y)
    map[x][y].class == Player
  end

  def open?(x, y)
    map[x][y].class == String
  end
end
