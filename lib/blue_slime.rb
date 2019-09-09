# frozen_string_literal: true

class BlueSlime < Enemy
  def initialize(x = nil, y = nil, _symbol = '?')
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'B'
    @facing = integer_to_direction rand(1..2)
    @turn = 0
  end

  def take_turn
    if turn.even?
      move(facing)
    else
      change_direction
    end
    @turn += 1
  end

  def change_direction
    flip_direction
  end
end
