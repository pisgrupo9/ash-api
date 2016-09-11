class CreateAnimals < ActiveRecord::Migration
  def change
    create_table :animals do |t|
      t.string :chip_num
      t.string :name, null: false
      t.string :race
      t.integer :sex,  null: false
      t.boolean :vaccines,  null: false
      t.boolean :castrated,  null: false
      t.date :admission_date,  null: false
      t.date :birthdate,  null: false
      t.date :death_date
      t.references :species, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
