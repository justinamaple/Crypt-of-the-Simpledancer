class Unlock < ActiveRecord::Base
  belongs_to :run
  belongs_to :achievement
end