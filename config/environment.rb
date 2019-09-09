require 'bundler/setup'
require 'yaml'
require 'sinatra/activerecord'

Bundler.require

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}

DB = ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/game.db'
)
