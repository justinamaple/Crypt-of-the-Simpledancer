class Unlock < ActiveRecord::Base
  belongs_to :run
  belongs_to :achievement
  has_one :user, through: :run
end