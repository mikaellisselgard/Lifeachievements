json.extract! @user, :avatar_url, :email, :name, :created_at, :updated_at
json.bucketlist @user_bucketlist_achievements
json.notice_infos @current_user.notice_infos
json.follow_infos @user.follow_infos
json.follower_infos @user.follower_infos
json.posts @json_posts
json.achievements @json_achievements
json.user_score @user_score