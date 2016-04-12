class AddDefaultValueCommentsCountPosts < ActiveRecord::Migration
  def change
  	change_column :posts, :comments_count, :integer, default: 0
  end
end
