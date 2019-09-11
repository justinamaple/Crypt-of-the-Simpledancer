# frozen_string_literal: true
require_relative 'enemy'

class BlueSlime < Enemy
  def initialize(x = nil, y = nil, _symbol = '?')
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'B'
    @facing = integer_to_direction rand(1..2)
    @health = 2
    @attack = 1
  end

  def take_turn(turn)
    if turn.even?
      move(facing)
    else
      change_direction
      move(:stay)
    end
  end

  def change_direction
    flip_direction
  end
end
