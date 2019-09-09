class CreateRunsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :runs do |t|
      t.integer :score
      t.integer :turns
      t.integer :level
      t.integer :user_id
      t.timestamps
    end
  end
end
