# frozen_string_literal: true

class Menu
  attr_accessor :test

  def initialize; end

  def print_banner(user)
    puts '============================================'
    puts '===      Crypt of the Simpledancer!      ==='
    puts '============================================'
    puts " User: #{user.username}"
    last_run = Run.where('user_id = ?', user.id)
                  .last
    best_run = Run.where('user_id = ?', user.id)
                  .order(levels_cleared: :desc, turns: :asc)
                  .limit(1)[0]
    puts ' New Player Detected, Best of Luck <3' unless last_run
    if last_run
      print " Last Run: Level #{last_run.levels_cleared}, %3d turns " % last_run.turns
      puts "on #{last_run.updated_at.strftime('%d/%m/%Y')}"
    end
    if best_run
      print " Best Run: Level #{best_run.levels_cleared}, %3d turns " % best_run.turns
      puts "on #{best_run.updated_at.strftime('%d/%m/%Y')}"
    end
  end

  def print_options
    puts
    puts 'Menu:'
    puts '1. Start Game'
    puts '2. Change Username'
    puts '3. Display Leaderboard'
    puts '4. Show Achievements'
    puts '5. Exit Game'
    puts
    print 'Press a number to begin: '
  end

  def find_or_create_user(username = nil)
    return User.find_or_create_by(username: username) if username

    clear_terminal
    print 'Please enter a username: '
    input = STDIN.gets.strip
    clear_terminal
    User.find_or_create_by(username: input)
  end

  def print_high_scores
    top_ten = Run.all
                 .order(levels_cleared: :desc, turns: :asc)
                 .limit(10)

    clear_terminal
    puts '==========================================='
    puts '===         Top 10: Hall of FAME        ==='
    puts '==========================================='
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

    puts '=============================================='
    puts format('====       %8s\'s Achievements        ====', user.username)
    puts '=============================================='
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
      unlocked = user.achievements.include?(achievement) ? '✓' : ' '
      stars = ''
      achievement.difficulty.times { stars += '*' }
      print format("[%s] %-22s - %-5s", unlocked, achievement.achievement_name, stars)
      puts '%12s' % achievement.created_at.strftime('%d/%m/%Y')
      puts "\t-%s" % achievement.condition
    end
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
    puts "Controls: ← ↓ ↑ →, 'Q': quit\n"
  end

  def clear_terminal
    system 'clear'
  end
end
