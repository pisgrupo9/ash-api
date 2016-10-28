class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :adopter, index: true, foreign_key: true
      t.string :text, null: false

      t.timestamps null: false
    end
  end
end
