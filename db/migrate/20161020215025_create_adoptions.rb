class CreateAdoptions < ActiveRecord::Migration
  def change
    create_table :adoptions do |t|
      t.integer :animal_id, null: false
      t.references :adopter, index: true, foreign_key: true, null: false
      t.date :date, null: false
      t.timestamps null: false
    end
    add_index :adoptions, :animal_id, unique: true
    add_foreign_key :adoptions, :animals
  end
end
