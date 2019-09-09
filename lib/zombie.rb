# frozen_string_literal: true

class Zombie < Enemy
  def initialize(x = nil, y = nil)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'Z'
    @facing = integer_to_direction rand(0..3)
    @turn = 0
  end

  def take_turn
    move(facing) if turn.even?
    move(:stay) if turn.odd?
    @turn += 1
  end

  def change_direction
    flip_direction
  end
end
