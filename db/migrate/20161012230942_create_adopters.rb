class CreateAdopters < ActiveRecord::Migration
  def change
    create_table :adopters do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :ci, null: false
      t.string :email, default: ""
      t.string :phone, null: false
      t.string :house_description, default: ""
      t.boolean :blacklisted, default: false, null: false
      t.string :home_address, null: false

      t.timestamps null: false
    end
  end
end
