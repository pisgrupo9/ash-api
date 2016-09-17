class AddProfileImageToAnimals < ActiveRecord::Migration
  def change
    add_column :animals, :profile_image, :string
  end
end
