json.array!(@json_posts) do |post|
  json.extract! post, :id, :user_id, :achievement_id, :likes_count, :comments_count, :commenter_infos
  json.user_avatar_url post.user.avatar_url
  json.user_name post.user.name
  json.achievement_score post.achievement.score
  json.achievement_desc post.achievement.description
  json.image_url post.image_url
  json.video_url post.video_url
  json.url post_url(post, format: :json)
end
