class AddEventIdToImages < ActiveRecord::Migration
  def change
    add_reference :images, :event, index: true, foreign_key: true
  end
end
