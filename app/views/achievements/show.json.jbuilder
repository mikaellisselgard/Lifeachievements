json.extract! @achievement, :id, :description, :score, :created_at, :updated_at, :posts
json.completer_infos @achievement.completer_user_infos
json.bucketlist @achievement.check_if_in_bucketlist(@current_user)
json.completed @achievement.check_if_completed(@current_user)
json.post_id @achievement.check_user_post(@current_user)
json.like @current_user.check_like_in_posts(@achievement.posts)
json.video_urls @video_urls