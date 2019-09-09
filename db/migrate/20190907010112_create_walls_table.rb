class CreateWallsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :walls do |t|
      t.integer :pos_x
      t.integer :pos_y
      t.timestamps
    end
  end
end
