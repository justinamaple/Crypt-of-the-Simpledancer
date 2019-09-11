# frozen_string_literal: true

class Wall < Unit
  def initialize(x, y)
    @x = x
    @y = y
    @symbol = 'X'
    @health = 9_999
  end
end
