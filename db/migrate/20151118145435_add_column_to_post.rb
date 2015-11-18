class AddColumnToPost < ActiveRecord::Migration
  def change
    add_column :posts, :likes_count, :int
  end
end
