# frozen_string_literal: true
require_relative 'unit'
class Enemy < Unit
  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end
end
