class CreateJoinTableCategoryAchievement < ActiveRecord::Migration
  def change
    create_join_table :categories, :achievements do |t|
      # t.index [:category_id, :achievement_id]
      # t.index [:achievement_id, :category_id]
    end
  end
end
