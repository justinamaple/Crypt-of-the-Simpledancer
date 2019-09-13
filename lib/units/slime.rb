# frozen_string_literal: true

require_relative 'enemy'

class Slime < Enemy
  def initialize(x, y)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'O'
    @facing = integer_to_direction rand(0..3)
    @health = 1
    @attack = 1
  end
end
