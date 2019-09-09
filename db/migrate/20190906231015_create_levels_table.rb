class CreateLevelsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.integer :size_x
      t.integer :size_y
      t.integer :speed
      t.datetime :time
      t.timestamps
    end
  end
end
