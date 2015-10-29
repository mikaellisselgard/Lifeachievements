class CreateJoinTableAchievementBucketList < ActiveRecord::Migration
  def change
    create_join_table :achievements, :bucket_lists do |t|
      # t.index [:achievement_id, :bucket_list_id]
      # t.index [:bucket_list_id, :achievement_id]
    end
  end
end
