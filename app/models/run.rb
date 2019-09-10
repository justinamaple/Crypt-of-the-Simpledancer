class Run < ActiveRecord::Base
  belongs_to :user
  has_many :unlocks
  has_one :run, through: :unlocks
end