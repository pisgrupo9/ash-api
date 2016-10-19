class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :name
      t.string :url
      t.integer :type_file
      t.integer :state
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
