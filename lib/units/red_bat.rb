# frozen_string_literal: true
require_relative 'bat'

class RedBat < Bat
  def take_turn(level)
    make_move(level)
    @turns += 1
  end
end
