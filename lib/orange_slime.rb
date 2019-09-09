# frozen_string_literal: true

class OrangeSlime < Enemy
  def initialize(x = nil, y = nil)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'O'
    @facing = integer_to_direction rand(0..3)
    @turn = 0
  end

  def take_turn(_turn)
    move(facing)
    change_direction
  end

  def change_direction
    rotate_direction
  end
end
