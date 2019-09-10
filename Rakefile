require_relative 'config/environment.rb'
require_relative './lib/game'
require_relative './lib/level'
require_relative './lib/unit'
require_relative './lib/wall'
require_relative './lib/player'
require_relative './lib/enemy'
require_relative './lib/green_slime'
require_relative './lib/blue_slime'
require_relative './lib/orange_slime'
require_relative './lib/zombie'
require 'yaml'
require 'matrix'
require "sinatra/activerecord/rake"

desc "starts console"
task :console do
  Pry.start
end

desc "starts game"
task :start_game do
  Game.new.login
end
