# frozen_string_literal: true

class Menu
  attr_accessor :test

  def initialize; end

  def print_banner(user)
    puts '==========================================='
    puts '===      Crypt of the Simpledancer!     ==='
    puts '==========================================='
    puts "User: #{user.username}"
    last_run = Run.where('user_id = ?', user.id)
                  .last
    best_run = Run.where('user_id = ?', user.id)
                  .order(levels_cleared: :desc, turns: :asc)
                  .limit(1)[0]
    puts "New Player Detected, Best of Luck <3" unless last_run
    if last_run
      print "Last Run: Level #{last_run.levels_cleared}, #{last_run.turns} turns "
      puts "on #{last_run.updated_at.strftime('%d/%m/%Y')}"
    end
    if best_run
      print "Best Run: Level #{best_run.levels_cleared}, #{best_run.turns} turns "
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
    puts '===       Top 10: Hall of FAME          ==='
    puts '==========================================='
    top_ten.each_with_index do |run, index|
      if run
        puts '%4d. %10s - Level %2d in %3d turns' % [
          index + 1, run.user.username, run.levels_cleared, run.turns
        ]
      end
    end
    puts 'No runs recorded yet!' unless top_ten[0]
  end

  def print_achievements(user)
    clear_terminal
    user_runs = Run.where(user_id: user.id)
    unlock_achievements(user_runs)

    puts '==========================================='
    puts '===      %8s\'s Achievements        ===' % [user.username]
    puts '==========================================='

    if user_runs.empty?
      puts "You are a n00b!1!"
    else
      puts 'Total Games: %4d' % user_runs.count
      puts 'Total Levels: %3d' % user_runs.sum(&:levels_cleared)
      puts 'Total Turns: %4d' % user_runs.sum(&:turns)
      puts

    end

  end

  def unlock_achievements(user_runs)
    # Should refactor the unlocker to happen only off the last run right before 
    # recording. This would make it so that you wouldn't have to worry about 
    # unlocking each achievement too many times.
    Achievement.all
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
    puts "Invalid Input Entered. Please enter a valid number"
  end

  def print_controls
    puts "Type 'a': ←, 's': ↓, 'w': ↑, 'd': →\n"
  end

  def clear_terminal
    system 'clear'
  end
end
