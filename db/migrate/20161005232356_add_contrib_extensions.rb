class AddContribExtensions < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION unaccent"
  end
end
