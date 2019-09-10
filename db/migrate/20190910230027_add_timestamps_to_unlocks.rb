class AddTimestampsToUnlocks < ActiveRecord::Migration[6.0]
  def change
    add_column :unlocks, :created_at, :datetime, null: false, default: Time.new
    add_column :unlocks, :updated_at, :datetime, null: false, default: Time.new
  end
end
