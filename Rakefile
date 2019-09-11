require_relative 'config/environment.rb'
require_all './lib'
require 'yaml'
require 'matrix'
require 'rest-client'
require 'JSON'
require "sinatra/activerecord/rake"

desc "starts console"
task :console do
  Pry.start
end

desc "starts game"
task :start_game do
  Game.new.menu_screen
end
