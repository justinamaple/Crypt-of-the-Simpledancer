# frozen_string_literal: true

require_relative 'skeleton'

class BlackSkeleton < Skeleton
  def initialize(x, y)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = '$'
    @facing = integer_to_direction rand(0..3)
    @health = 3
    @attack = 1
    @turns = rand(0..1)
  end

  def take_dmg(dmg_amount)
    @health -= dmg_amount
    case @health
    when 2
      @symbol = 'S'
    when 1
      @symbol = 's'
    end
  end
end
