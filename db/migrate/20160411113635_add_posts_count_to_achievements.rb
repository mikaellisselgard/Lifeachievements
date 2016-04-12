class AddPostsCountToAchievements < ActiveRecord::Migration
  def change
    add_column :achievements, :posts_count, :integer
  end
end
