class AddAdoptableToSpecies < ActiveRecord::Migration
  def change
    add_column :species, :adoptable, :boolean, null: false
  end
end
