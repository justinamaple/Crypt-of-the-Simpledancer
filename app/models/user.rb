class User < ActiveRecord::Base
  has_many :runs
  has_many :unlocks, through: :runs
  has_many :achievements, through: :unlocks
end