class ChangeDefaultValuePostsCount < ActiveRecord::Migration
  def change
  	change_column :achievements, :posts_count, :integer, default: 0
  end
end
