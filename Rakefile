require_relative 'config/environment.rb'
require_relative 'game.rb'
require "sinatra/activerecord/rake"

desc "starts console"
task :console do
  Pry.start
end

desc "starts game"
task :start do
  game = Game.new
  game.display_menu
end
