# frozen_string_literal: true

class Menu
  attr_accessor :test

  def initialize; end

  def print_banner(user)
    puts '============================================'.colorize(:light_yellow)
    puts '===      Crypt of the Simpledancer!      ==='.colorize(:light_yellow)
    puts '============================================'.colorize(:light_yellow)
    puts " User: #{user.username.colorize(:light_blue)}\t\t      Appearance: #{user.symbol.colorize(:light_white)}"
    last_run = Run.where('user_id = ?', user.id)
                  .last
    best_run = Run.where('user_id = ?', user.id)
                  .order(levels_cleared: :desc, turns: :asc)
                  .limit(1)[0]
    puts ' New Player Detected, Best of Luck <3' unless last_run
    if last_run
      print ' Last Run:'
      print " Level #{last_run.levels_cleared}, %3d turns ".colorize(:magenta) % last_run.turns
      puts "on #{last_run.updated_at.strftime('%d/%m/%Y')}"
    end
    if best_run
      print ' Best Run: '
      print "Level #{best_run.levels_cleared}, %3d turns ".colorize(:cyan) % best_run.turns
      puts "on #{best_run.updated_at.strftime('%d/%m/%Y')}"
    end
  end

  def print_options
    puts
    puts 'Menu:'.colorize(:light_yellow)
    puts '1. Start Game'
    puts '2. Change User'
    puts '3. Change Appearance'
    puts '4. Display Leaderboard'
    puts '5. Show Achievements'
    puts '6. Exit Game'
    puts
    print 'Press the number to begin: '
  end

  def find_or_create_user
    clear_terminal
    print 'Please enter a username: '
    input = STDIN.gets.strip
    clear_terminal
    user = User.find_by(username: input)
    user ||= User.create(username: input, symbol: '@')
    user
  end

  def print_high_scores
    top_ten = Run.all
                 .order(levels_cleared: :desc, turns: :asc)
                 .limit(10)

    clear_terminal
    puts '==========================================='.colorize(:light_yellow)
    puts '===         Top 10: Hall of FAME        ==='.colorize(:light_yellow)
    puts '==========================================='.colorize(:light_yellow)
    top_ten.each_with_index do |run, index|
      next unless run

      puts format('%4d. %10s - Level %2d in %3d turns',
                  index + 1, run.user.username, run.levels_cleared, run.turns)
    end
    puts 'No runs recorded yet!' unless top_ten[0]
  end

  def print_achievements(user)
    clear_terminal
    user_runs = Run.all.where(user: user)
    unlock_achievements(user_runs)
    get_age_api(user)
    user.reload

    puts '=============================================='.colorize(:light_yellow)
    puts format('====       %8s\'s Achievements        ===='.colorize(:light_yellow), user.username)
    puts '=============================================='.colorize(:light_yellow)
    print_aggregate_stats(user)
    print_individual_achievements(user)
  end

  def get_age_api(user)
    if user.age.nil?
      json_response = RestClient.get('https://api.agify.io/?name=' + user.username.downcase)
      response = JSON.parse(json_response)
      user.update(age: response['age']) if response['age']
    end
  end

  def unlock_achievements(user_runs)
    # Should refactor the unlocker to happen only off the last run right before
    # recording. This would make it so that you wouldn't have to worry about
    # unlocking each achievement too many times.
    Achievement.all.each do |achievement|
      success_runs = user_runs.where(achievement.condition)
      unless success_runs.empty?
        Unlock.find_or_create_by(achievement: achievement, run: success_runs[0])
      end
    end
  end

  def print_aggregate_stats(user)
    user.reload
    if user.runs.empty?
      puts 'You are a n00b!1!'
    else
      puts format('%12s Total Games: %7d', '', user.runs.count)
      puts format('%12s Total Levels: %6d', '', user.runs.sum(&:levels_cleared))
      puts format('%12s Total Turns: %7d', '', user.runs.sum(&:turns))
      time_played = user.runs.sum do |run|
        run.updated_at - run.created_at
      end
      puts format('%12s Time Played: %7s', '', Time.at(time_played).strftime('%M:%S'))
      user_age = user.age ? user.age.to_s : '??'
      puts format('%12s Estimated Age: %5s', '', user_age)
      puts
    end
  end

  def print_individual_achievements(user)
    Achievement.all.order(difficulty: :asc).uniq.each do |achievement|
      unlocked = user.achievements.include?(achievement) ? '✓'.colorize(:light_green) : ' '
      stars = ''
      achievement.difficulty.times { stars += '★ ' }
      print format('[%s] %-22s - %-24s', unlocked, achievement.achievement_name, stars.colorize(:light_yellow))
      if unlocked != ' '
        puts '%12s' % user.unlocks.where(achievement: achievement)[0].created_at.strftime('%m/%d/%Y')
      else
        puts
      end
      puts "\t-%s" % achievement.condition
    end
  end

  def print_update_symbol(user)
    clear_terminal
    puts 'Enter a symbol to represent your character: '
    symbol = get_input_s.chars.first
    print_update_symbol(user) unless symbol
    user.update(symbol: symbol)
  end

  def exit_game
    puts
    abort 'Thanks for playing!'
  end

  def get_input_ch
    STDIN.getch
  end

  def get_input_s
    STDIN.gets.chomp
  end

  def invalid_input
    puts 'Invalid Input Entered. Please enter a valid number'
  end

  def print_controls
    print 'Controls: '
    print '← ↓ ↑ →'.colorize(:green)
    print ', '
    print "'Q'".colorize(:light_yellow)
    puts ": quit\n"
  end

  def clear_terminal
    system 'clear'
  end
end
