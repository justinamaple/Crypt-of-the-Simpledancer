# frozen_string_literal: true

require_relative 'slime'

class BlueSlime < Slime
  def initialize(x, y)
    @x = x
    @y = y
    @last_location = { x: x, y: y }
    @symbol = 'O'
    @facing = integer_to_direction rand(1..2)
    @health = 2
    @attack = 1
    @turns = 0
  end

  def take_turn(_level)
    if @turns.even?
      move(facing)
    else
      change_direction
      move(:stay)
    end
    @turns += 1
  end

  def change_direction
    flip_direction
  end

  def reset_position
    # Special override since if it attacks, and gets reset
    # it should try and attack again on the next turn.
    @x = last_location[:x]
    @y = last_location[:y]
    @facing = last_direction
    @turns -= 1
  end

  def take_dmg(dmg_amount)
    @health -= dmg_amount
    @symbol = 'o' if @health == 1
  end
end
