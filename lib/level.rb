# frozen_string_literal: true

class Level
  attr_accessor :map, :turns
  attr_reader :max_x, :max_y

  def initialize
    @max_x = 8
    @max_y = 8
    @map = Array.new(max_x) { Array.new(max_y) }
    create_stage
  end

  def create_stage
    @turns = 0
    max_x.times do |x|
      max_y.times do |y|
        map[x][y] = if x.zero? || x == max_x - 1 || y.zero? || y == max_y - 1
                      Wall.new(x, y)
                    else
                      '-'
                    end
      end
    end
  end

  def to_s
    board_string = "\n"
    # Need to print top -> down
    max_y.times do |y|
      inverse_y = max_y - 1 - y
      max_x.times do |x|
        unit = map[x][inverse_y]
        board_string += case unit
                        when String
                          disco_floor(x, y)
                        else
                          " #{map[x][inverse_y]}"
                        end
      end
      board_string += "\n"
    end
    board_string += "\n"
    board_string
  end

  def disco_floor(x, y)
    if turns.even?
      if x.odd? && y.odd?
        ' -'
      elsif x.even? && y.odd?
        '  '
      elsif x.odd? && y.even?
        '  '
      else # x.even? && y.even?
        ' -'
      end
    else # turn.odd?
      if x.odd? && y.odd?
        '  '
      elsif x.even? && y.odd?
        ' -'
      elsif x.odd? && y.even?
        ' -'
      else # x.even? && y.even?
        '  '
      end
    end
  end
end
