class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.date :date, null: false
      t.references :animal, index: true, foreign_key: true, null: false
    end
  end
end
