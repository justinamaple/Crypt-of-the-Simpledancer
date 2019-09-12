# frozen_string_literal: true

class Unit
  attr_accessor :x, :y, :last_location, :last_direction, :symbol, :facing
  attr_accessor :health, :attack

  def initialize(x = nil, y = nil, symbol = '?')
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @last_direction = nil
    @symbol = symbol
    @facing = nil
    @health = 1
    @attack = 1
  end

  def save_last_move
    @last_location = { x: @x, y: @y }
    @last_direction = @facing
  end

  def reset_position
    @x = last_location[:x]
    @y = last_location[:y]
    @facing = last_direction
  end

  def take_dmg(dmg_amount)
    @health -= dmg_amount
  end

  def dead?
    @health <= 0
  end

  def left
    @x -= 1
    @facing = :left
  end

  def down
    @y -= 1
    @facing = :down
  end

  def up
    @y += 1
    @facing = :up
  end

  def right
    @x += 1
    @facing = :right
  end

  def move(input)
    save_last_move
    case input
    when :left
      left
    when :down
      down
    when :up
      up
    when :right
      right
    end
  end

  def flip_direction
    case @facing
    when :left
      @facing = :right
    when :down
      @facing = :up
    when :up
      @facing = :down
    when :right
      @facing = :left
    end
  end

  def rotate_direction
    case @facing
    when :left
      @facing = :up
    when :down
      @facing = :left
    when :up
      @facing = :right
    when :right
      @facing = :down
    end
  end

  def check_direction(x, y, direction)
    case direction
    when :left
      x -= 1
    when :down
      y -= 1
    when :up
      y += 1
    when :right
      x += 1
    end
    { x: x, y: y }
  end

  def integer_to_direction(integer)
    direction = nil
    case integer
    when 0
      direction = :left
    when 1
      direction = :down
    when 2
      direction = :up
    when 3
      direction = :right
    end
    direction
  end

  def to_s
    @symbol
  end
end
