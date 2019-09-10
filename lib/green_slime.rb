# frozen_string_literal: true

class GreenSlime < Enemy
  def initialize(x = nil, y = nil)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'G'
    @turn = 0
  end

  def take_turn(_turn); end

  def change_direction; end
end
