# frozen_string_literal: true
require_relative 'enemy'

class Bat < Enemy
  def initialize(x = nil, y = nil)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'B'
    @facing = integer_to_direction rand(0..3)
    @health = 1
    @attack = 1
  end

  def take_turn(level)
    if level.turns.even?
      facing = integer_to_direction rand(1..2)
      move(facing)
    else
      change_direction
      move(:stay)
    end
  end

  def change_direction
    flip_direction
  end

  def take_dmg(dmg_amount)
    @health -= dmg_amount
    @symbol = 's' if @health == 1
  end
end
