# frozen_string_literal: true

require_relative 'skeleton'

class YellowSkeleton < Skeleton
  def initialize(x, y)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'S'
    @facing = integer_to_direction rand(0..3)
    @health = 2
    @attack = 1
    @turns = rand(0..1)
  end

  def take_dmg(dmg_amount)
    @health -= dmg_amount
    @symbol = 's' if @health == 1
  end
end
