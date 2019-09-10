# frozen_string_literal: true
require 'io/console'
class Game
  attr_accessor :level, :killer, :user, :run, :levels_cleared, :total_turns
  attr_reader :enemy, :player

  GAME_CLEAR = 9

  def initialize
    @levels_cleared = 0
    @total_turns = 0
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
    (@levels_cleared + 2).times do
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
        enemy = Zombie.new(x, y)
      end
      Enemy.all << enemy
      level.map[enemy.x][enemy.y] = enemy
    end
  end

  def login
    system 'clear'
    print_leaderboard
    get_username
    play
  end

  def get_username
    print 'Please enter a username: '
    input = STDIN.gets.chomp
    @user = User.find_or_create_by(username: input)
    @run = Run.create(user_id: @user.id)
  end

  def print_leaderboard
    top_five = Run.all
                  .order(levels_cleared: :desc, turns: :asc)
                  .limit(5)

    puts '====================================='
    puts 'Welcome to Crypt of the Simpledancer!'
    puts '====================================='
    puts 'High Scores:'
    top_five.each_with_index do |run, index|
      if run
        print "#{index + 1}. #{run.user.username} - Level #{run.levels_cleared}"
        puts " in #{run.turns} turns"
      end
    end
    puts 'No runs recorded yet!' unless top_five[0]
    puts
  end

  def play
    until won? || lost?
      system 'clear'
      puts level
      move_player
      move_enemies
    end

    @total_turns += level.turns
    if won?
      @levels_cleared += 1
      setup_level
      if levels_cleared >= GAME_CLEAR
        win_screen
      else
        play
      end
    elsif lost?
      lose_screen
    end
    record_run
    puts 'Try again? (y/n)'
    input = STDIN.gets.chomp.downcase
    if input == 'y'
      @run = Run.create(user_id: @user.id)
      setup_level
      play
    end
    exit_game
  end

  def won?
    Enemy.all.empty?
  end

  def lost?
    Player.all.empty?
  end

  def record_run
    @run.update(turns: @total_turns, levels_cleared: levels_cleared)
    @levels_cleared = 0
  end

  def win_screen
    puts 'You are a Winner!!!'
    puts "Cleared level #{levels_cleared} in #{@total_turns} turns"
  end

  def lose_screen
    puts 'You are a LOSER!!!'
    puts "Killed by a #{killer.class} on turn #{@total_turns}"
  end

  def move_player
    print_controls
    input = STDIN.getch.chomp.downcase
    direction = translate_controls(input)
    Player.all.clear if direction == :quit
    move_player if direction == :stay
    level.turns += 1 if direction != :stay
    player.move(direction)
    check_move(player)
  end

  def move_enemies
    Enemy.all.each do |enemy|
      enemy.take_turn(level.turns)
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
      attacker.undo_last_move
      attacker.change_direction if attacker.class <= Enemy
    when Enemy
      if attacker.class == Player
        Enemy.all.delete(defender)
        reset_last_location(attacker)
      else
        attacker.change_direction
        attacker.undo_last_move
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
    print "User: #{@user.username}  "
    print "Turn: #{level.turns}  "
    puts "Level: #{levels_cleared}"
    puts "Type 'a': ←, 's': ↓, 'w': ↑, 'd': →\n"
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
