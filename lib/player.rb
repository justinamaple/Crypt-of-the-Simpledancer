# frozen_string_literal: true

class Player < Unit
  @@all = []

  def initialize
    @x = 4
    @y = 4
    @symbol = '@'
    @last_location = { x: @x, y: @y }
    @facing = nil
    @health = 3
    @attack = 1
    @@all << self
  end

  def self.all
    @@all
  end
end
