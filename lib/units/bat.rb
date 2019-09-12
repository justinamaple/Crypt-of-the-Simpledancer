# frozen_string_literal: true
require_relative 'enemy'

class Bat < Enemy
  def initialize(x, y)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'B'
    @facing = integer_to_direction rand(0..3)
    @health = 1
    @attack = 1
    @turns = rand(0..1)
  end

  def take_turn(level)
    if @turns.even?
      make_move(level)
    else
      move(:stay)
    end
    @turns += 1
  end

  def make_move(level)
    possible_directions = *(0..3).map(&method(:integer_to_direction))
    until possible_directions.empty?
      direction = possible_directions.shuffle!.pop
      next_x, next_y = *next_coords_in_direction(x, y, direction)
      if level.open?(next_x, next_y) || level.player?(next_x, next_y)
        move(direction)
        break
      end
    end
  end

  def change_direction
    # Do nothing since it moves randomly each turn
  end
end
