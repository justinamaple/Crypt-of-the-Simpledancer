# frozen_string_literal: true

require_relative 'enemy'

class OrangeSlime < Slime
  def take_turn(_level)
    move(facing)
    change_direction
  end

  def change_direction
    rotate_direction
  end
end
