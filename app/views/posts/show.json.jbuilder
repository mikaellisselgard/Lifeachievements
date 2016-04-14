json.extract! @post, :image, :video, :user_id, :achievement_id, :likes_count, :commenter_infos, :like_infos, :created_at, :updated_at
json.achievement_score @post.achievement.score