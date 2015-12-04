class AddLocationColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :longitude, :float
    add_column :posts, :latitude, :float
  end
end
