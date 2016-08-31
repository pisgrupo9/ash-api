class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :account_active, :boolean, default: false
  end
end
