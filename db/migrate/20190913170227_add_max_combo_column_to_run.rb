class AddMaxComboColumnToRun < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :max_combo, :integer, default: 0
  end
end
