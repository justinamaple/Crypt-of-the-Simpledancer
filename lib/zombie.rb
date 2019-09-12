# frozen_string_literal: true

class Zombie < Enemy
  def initialize(x = nil, y = nil)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'Z'
    @facing = integer_to_direction rand(0..3)
    @health = 1
    @attack = 1
  end

  def take_turn(level)
    move(facing) if level.turns.even?
    move(:stay) if level.turns.odd?

    next_move = check_direction(x, y, facing)
    change_direction if level.map[next_move[:x]][next_move[:y]].class == Wall
  end

  def change_direction
    flip_direction
  end
end
