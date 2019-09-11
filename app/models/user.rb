class User < ActiveRecord::Base
  has_many :runs
  has_many :unlocks, through: :runs
  has_many :achievements, through: :unlocks
end


Achievement.create(achievement_name: 'Club Penguin Speedrun', difficulty: 2, condition: 'updated_at - created_at < 1')
Achievement.create(achievement_name: 'Beat the Game!', difficulty: 5, condition: 'levels_cleared > 8')