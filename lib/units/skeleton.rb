# frozen_string_literal: true

require_relative 'enemy'

class Skeleton < Enemy
  def initialize(x, y)
    @x = x
    @y = y
    @last_location = { x: @x, y: @y }
    @symbol = 'S'
    @facing = integer_to_direction rand(0..3)
    @health = 1
    @attack = 1
    @turns = rand(0..1)
  end

  def take_turn(level)
    if @turns.even?
      make_move(level)
    else
      move(:stay)
    end
    @turns += 1
  end

  def make_move(level)
    player_x, player_y = *level.find_player

    if x == player_x && y < player_y
      move(:up)
    elsif x == player_x && y > player_y
      move(:down)
    elsif x < player_x && y == player_y
      move(:right)
    elsif x > player_x && y == player_y
      move(:left)
    elsif x < player_x && y < player_y
      attack_or_move_towards_player(player_x, player_y, %i[up right])
    elsif x < player_x && y > player_y
      attack_or_move_towards_player(player_x, player_y, %i[down right])
    elsif x > player_x && y < player_y
      attack_or_move_towards_player(player_x, player_y, %i[up left])
    else # x > player_x && y > player_y
      attack_or_move_towards_player(player_x, player_y, %i[down left])
    end
  end

  def attack_or_move_towards_player(player_x, player_y, directions)
    directions.each do |direction|
      next_x, next_y = next_coords_in_direction(x, y, direction)
      if next_x == player_x && next_y == player_y
        move(direction)
        return
      end
    end

    move(directions.sample)
  end

  def reset_position
    # Special override since if it attacks, and gets reset
    # it should try and attack again on the next turn.
    @x = last_location[:x]
    @y = last_location[:y]
    @facing = last_direction
    @turns -= 1
  end

  def change_direction
    # When killed by the player hop in the opposite direction
  end
end
