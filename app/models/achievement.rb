class Achievement < ActiveRecord::Base
  has_many :unlocks
  has_one :run, through: :unlocks
end
