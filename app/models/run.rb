class Run < ActiveRecord::Base
  belongs_to :user
  has_many :unlocks
  has_many :achievements, through: :unlocks
end