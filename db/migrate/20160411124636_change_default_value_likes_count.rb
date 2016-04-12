class ChangeDefaultValueLikesCount < ActiveRecord::Migration
  def change
  	change_column :posts, :likes_count, :integer, default: 0
  end
end
