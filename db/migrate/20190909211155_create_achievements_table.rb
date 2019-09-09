class CreateAchievementsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements do |t|
      t.string :achievement_name
      t.integer :difficulty
      t.string :condition
      t.timestamps
    end
  end
end
