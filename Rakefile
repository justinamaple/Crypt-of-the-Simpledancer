# frozen_string_literal: true

require_relative 'config/environment.rb'
require_all './lib'
require 'yaml'
require 'matrix'
require 'rest-client'
require 'json'
require 'colorize'
require 'sinatra/activerecord/rake'
require 'active_support'
require 'active_support/core_ext/object'

desc 'starts console'
task :console do
  Pry.start
end

desc 'starts game'
task :start_game do
  Game.new.menu_screen
end
