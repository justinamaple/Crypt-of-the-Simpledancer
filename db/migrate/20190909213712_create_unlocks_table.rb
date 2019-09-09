class CreateUnlocksTable < ActiveRecord::Migration[6.0]
  def change
    create_table :unlocks do |t|
      t.integer :run_id
      t.integer :achievement_id
    end
  end
end
