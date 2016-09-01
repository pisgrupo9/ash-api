class AddAccessLevelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_level, :integer, default: 0
  end
end
