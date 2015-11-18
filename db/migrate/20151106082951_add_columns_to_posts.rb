class AddColumnsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :height, :string
    add_column :posts, :width, :string
  end
end
