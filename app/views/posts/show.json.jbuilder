json.extract! @post, :image, :video, :user_id, :achievement_id, :likes_count, :comments_count, :commenter_infos, :like_infos, :created_at, :updated_at
json.achievement_score @post.achievement.score
json.user_avatar_url @post.user.avatar_url
json.user_name @post.user.name
json.image_url @post.image_url
json.achievement_description @post.achievement.description
json.achievement_score @post.achievement.score