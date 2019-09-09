# frozen_string_literal: true

class Game
  attr_accessor :level, :killer
  attr_reader :enemy, :player

  def initialize
    setup_level
  end

  def setup_level
    # Coordinate branch out from the bottom left
    # (0,0) = bot left   (max_x, max_y) = top right
    @level = Level.new
    spawn_player
    spawn_enemies
  end

  def spawn_player
    Player.all.clear
    @player = Player.new
    level.map[player.x][player.y] = player
  end

  def spawn_enemies
    Enemy.all.clear
    6.times do
      # TODO: Definitely some way to clean this up
      x = 0
      y = 0 
      loop do
        x = rand(2..level.max_x - 3)
        y = rand(2..level.max_y - 3)
        break if level.map[x][y].class == String
      end

      enemy_type = rand(0..3)
      enemy = nil
      case enemy_type
      when 0
        enemy = GreenSlime.new(x, y)
      when 1
        enemy = BlueSlime.new(x, y)
      when 2
        enemy = OrangeSlime.new(x, y)
      when 3
        enemy = Zombie.new(x,y)
      end
      Enemy.all << enemy
      level.map[enemy.x][enemy.y] = enemy
    end
  end

  def play
    until won? || lost?
      system 'clear'
      puts level
      move_player
      move_enemies
    end
    if won?
      win_screen
    elsif lost?
      lose_screen
    end
    puts 'Try again? (y/n)'
    input = gets.chomp.downcase
    if input == 'y'
      setup_level
      play
    end
    exit_game
  end

  def won?
    Enemy.all.empty?
  end

  def win_screen
    puts 'You are a Winner!!!'
    puts "It only took you #{player.turn} turns"
  end

  def lost?
    Player.all.empty?
  end

  def lose_screen
    puts 'You are a LOSER!!!'
    puts "Killed by a #{killer.class} on turn #{player.turn}"
  end

  def move_player
    print_controls
    input = gets.chomp.downcase
    direction = translate_controls(input)
    exit_game if direction == :quit
    move_player if direction == :stay
    player.turn += 1 if direction != :stay
    player.move(direction)
    check_move(player)
  end

  def move_enemies
    Enemy.all.each do |enemy|
      enemy.take_turn
      check_move(enemy)
    end
  end

  def check_move(unit)
    check_collisions(unit)
    level.map[unit.x][unit.y] = unit
  end

  def check_collisions(attacker)
    defender = level.map[attacker.x][attacker.y]

    case defender
    when Wall
      attacker.undo_move
      if attacker.class <= Enemy
        attacker.change_direction
      end
    when Enemy
      if attacker.class == Player
        Enemy.all.delete(defender)
        reset_last_location(attacker)
      else
        attacker.undo_move
      end
    when Player
      if attacker.class <= Enemy
        @killer = attacker
        Player.all.delete(defender)
        reset_last_location(attacker)
      end
    when String
      reset_last_location(attacker)
    end
  end

  def reset_last_location(unit)
    level.map[unit.last_location[:x]][unit.last_location[:y]] = '-'
  end

  def print_controls
    puts "Turn: #{player.turn}"
    puts "Type 'h': ←, 'j': ↓, 'k': ↑, 'l': →, 'q': Quit.\n"
  end

  def translate_controls(input)
    output = :stay
    case input
    when /[ha]/
      output = :left
    when /[js]/
      output = :down
    when /[kw]/
      output = :up
    when /[ld]/
      output = :right
    when /[qx]/
      output = :quit
    end
    output
  end

  def exit_game
    abort 'Thanks for playing!'
  end
end
