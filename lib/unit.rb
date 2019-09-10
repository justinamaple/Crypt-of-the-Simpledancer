# frozen_string_literal: true

class Unit
  attr_accessor :x, :y, :last_location, :last_direction, :symbol, :facing, :health

  def initialize(x = nil, y = nil, symbol = '?')
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @last_direction = nil
    @symbol = symbol
    @facing = nil
    @health = 1
  end

  def save_last_move
    @last_location = { x: @x, y: @y }
    @last_direction = @facing
  end

  def undo_last_move
    @x = last_location[:x]
    @y = last_location[:y]
    @facing = last_direction
  end

  def left
    save_last_move
    @x -= 1
    @facing = :left
  end

  def down
    save_last_move
    @y -= 1
    @facing = :down
  end

  def up
    save_last_move
    @y += 1
    @facing = :up
  end

  def right
    save_last_move
    @x += 1
    @facing = :right
  end

  def up_left
    save_last_move
    @x -= 1
    @y += 1
  end

  def up_right
    save_last_move
    @x += 1
    @y += 1
  end

  def down_left
    save_last_move
    @x -= 1
    @y -= 1
  end

  def down_right
    save_last_move
    @x += 1
    @y -= 1
  end

  def move(input)
    case input
    when :left
      left
    when :down
      down
    when :up
      up
    when :right
      right
    when :stay
      save_last_move
    end
  end

  def flip_direction
    save_last_move
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

  def direction_to_integer(direction)
    integer = nil
    case direction
    when :left
      integer = 0
    when :down
      integer = 1
    when :up
      integer = 2
    when :right
      integer = 3
    when :up_left
      integer = 4
    when :up_right
      integer = 5
    when :down_left
      integer = 6
    when :down_right
      integer = 7
    end
    integer
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
    when 4
      direction = :up_left
    when 5
      direction = :up_right
    when 6
      direction = :down_left
    when 7
      direction = :down_right
    end
    direction
  end

  def to_s
    @symbol
  end
end
