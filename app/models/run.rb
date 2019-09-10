class Run < ActiveRecord::Base
  belongs_to :user
  has_many :unlocks
end