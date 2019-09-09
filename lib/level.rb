# frozen_string_literal: true

class Level
  attr_accessor :map, :test
  attr_reader :max_x, :max_y

  def initialize
    @test = 'test'
    @max_x = 8
    @max_y = 8
    @map = Array.new(max_x) { Array.new(max_y) }
    setup_level
  end

  def setup_level
    create_stage
  end

  def create_stage
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
        board_string += " #{map[x][inverse_y]}"
      end
      board_string += "\n"
    end
    board_string += "\n"
    board_string
  end
end
