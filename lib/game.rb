# frozen_string_literal: true

require 'io/console'
class Game
  attr_accessor :level, :user, :run, :levels_cleared, :total_turns, :combo, :max_combo
  attr_reader :enemy, :player, :menu, :all_enemies, :medium_enemies, :basic_enemies

  GAME_CLEAR = 9

  def initialize
    @menu = Menu.new
    @user = menu.find_or_create_user
    create_enemy_buckets
    menu.print_banner(user)
  end

  def start_new_game
    @total_turns = 0
    @levels_cleared = 0
    @combo = 0
    @max_combo = 0
    @player = Player.new(user.symbol || '@')
    @run = Run.create(
      user_id: @user.id,
      turns: total_turns,
      levels_cleared: levels_cleared
    )
    setup_level
  end

  def create_enemy_buckets
    @all_enemies = Enemy.descendants.select do |enemy|
      enemy.descendants.empty?
    end

    @medium_enemies = all_enemies.reject { |enemy| Skeleton.descendants.include?(enemy) }

    @basic_enemies = medium_enemies.reject { |enemy| Bat.descendants.include?(enemy) }
  end

  def setup_level
    # Coordinate branch out from the bottom left
    # (0,0) = bot left   (max_x, max_y) = top right
    @last_hit_player = nil
    @last_hit_enemy = nil
    @level = Level.new
    spawn_player
    spawn_enemies
  end

  def spawn_player
    player.x = rand(1..level.max_x - 2) if player.x >= level.max_x - 1
    player.y = rand(1..level.max_y - 2) if player.y >= level.max_y - 1
    level.map[player.x][player.y] = player
  end

  def spawn_enemies
    Enemy.all.clear
    (@levels_cleared + 2).times do
      x, y = *generate_empty_coordinates
      generate_random_enemy(x, y)
    end
  end

  def generate_empty_coordinates
    x = 0
    y = 0
    loop do
      x = rand(2..level.max_x - 3)
      y = rand(2..level.max_y - 3)
      break if level.map[x][y].class == String
    end
    [x, y]
  end

  def generate_random_enemy(x, y)
    case @levels_cleared
    when 0..1
      random_enemy_class = basic_enemies.sample
    when 2..4
      random_enemy_class = medium_enemies.sample
    when 5..10
      random_enemy_class = all_enemies.sample
    end
    enemy = random_enemy_class.new(x, y)
    Enemy.all << enemy
    level.map[enemy.x][enemy.y] = enemy
  end

  def menu_screen
    menu.print_options
    menu_input
    menu_screen
  end

  def menu_input
    input = menu.get_input_ch
    @user.reload
    case input
    when '1'
      start_new_game
      play
    when '2'
      @user = menu.find_or_create_user
      menu.print_banner(user)
    when '3'
      menu.print_update_symbol(user)
      user.reload
      menu.print_banner(user)
    when '4'
      menu.print_high_scores
    when '5'
      menu.print_achievements(user)
    when /[6qnx]/
      menu.exit_game
    else
      menu_input
    end
  end

  def play
    until won? || lost?
      system 'clear'
      print_last_turn_summary
      puts level
      print_stats
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
    try_again
  end

  def print_last_turn_summary
    if level.turns == 0
      puts 'You find yourself on a new floor!'
      puts 'The enemies ready themselves...'
    else
      if @last_hit_player
        if @last_hit_player.dead?
          puts "You destroyed #{@last_hit_player.class}!"
        elsif @last_hit_player.class == Wall
          puts "You kick the #{@last_hit_player.class} pointlessly..."
        else
          puts "You smack #{@last_hit_player.class} for #{player.attack}."
        end
      else
        puts 'You carefully tread deeper into the dungeon.'
      end

      if @last_hit_enemy
        puts "#{@last_hit_enemy.class} bops you for #{@last_hit_enemy.attack}."
      else
        puts 'The enemies sneer at you from a distance.'
      end
    end
    @last_hit_enemy = nil
  end

  def try_again
    puts 'Try again? (y/n)'
    input = menu.get_input_ch.downcase
    case input
    when 'y'
      start_new_game
      play
    when /[qxn]/
      menu.clear_terminal
      menu.print_banner(user)
      menu_screen
    else
      try_again
    end
  end

  def won?
    Enemy.all.empty?
  end

  def lost?
    @player.dead?
  end

  def record_run
    @run.update(turns: @total_turns, levels_cleared: levels_cleared)
    @levels_cleared = 0
  end

  def move_player
    input = STDIN.getch.chomp.downcase
    direction = translate_controls_arrows(input)
    if direction == :quit
      @last_hit_enemy = @player
      @player.health = 0
    end
    move_player if direction == :stay
    level.turns += 1 if direction != :stay
    player.move(direction)
    check_move(player)
  end

  def move_enemies
    Enemy.all.each do |enemy|
      enemy.take_turn(level)
      check_move(enemy)
      break if player.dead?
    end
  end

  def check_move(unit)
    check_collisions(unit)
    level.map[unit.x][unit.y] = unit
  end

  def check_collisions(attacker)
    defender = level.map[attacker.x][attacker.y]
    return if defender == attacker

    case defender
    when Wall
      @last_hit_player = defender if attacker.class == Player
      attacker.reset_position
      attacker.change_direction if attacker.class <= Enemy
    when Enemy
      if attacker.class == Player
        @last_hit_player = defender
        deal_damage(attacker, defender)
      else
        attacker.reset_position
      end
    when Player
      if attacker.class <= Enemy
        @last_hit_enemy = attacker
        deal_damage(attacker, defender)
      end
    when String
      if attacker.class == Player
        @last_hit_player = nil
      end

      reset_last_location(attacker)
    end
  end

  def deal_damage(attacker, defender)
    defender.take_dmg(attacker.attack)
    if defender.dead?
      reset_current_location(defender)
      case defender
      when Player
        # Catch it when next turn starts
      when Enemy
        Enemy.all.delete(defender)
      end
      reset_last_location(attacker)
    end
    attacker.reset_position
  end

  def reset_current_location(unit)
    level.map[unit.x][unit.y] = '-'
  end

  def reset_last_location(unit)
    level.map[unit.last_location[:x]][unit.last_location[:y]] = '-'
  end

  def win_screen
    puts 'You are a Winner!!!'.colorize(:green)
    puts "Cleared level #{levels_cleared} in #{@total_turns} turns"
  end

  def lose_screen
    puts 'You are a LOSER!!!'.colorize(:red)
    puts "Killed by a #{@last_hit_enemy.class} on turn #{@total_turns}"
  end

  def print_stats
    print "User: #{user.username.colorize(:light_blue)}  "
    print " Turn: #{level.turns.to_s.colorize(:light_cyan)}  "
    puts " Level: #{levels_cleared.to_s.colorize(:light_magenta)}"
    hearts = ''
    player.health.times { hearts += '❤ ' }
    puts "Health: #{hearts.colorize(:red)}"
    print "Weapon: "
    puts 'Dagger'.colorize(:cyan)
    @menu.print_controls
  end

  def translate_controls_arrows(input)
    output = :stay
    case input
    when /[d]/
      output = :left
    when /[b]/
      output = :down
    when /[a]/
      output = :up
    when /[c]/
      output = :right
    when /[q]/
      output = :quit
    end
    output
  end
end
