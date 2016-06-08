json.extract! @user, :avatar_url, :email, :name, :created_at, :updated_at
json.bucketlist @user_bucketlist_achievements
json.notice_infos @current_user.notice_infos
json.follow_infos @user.follow_infos
json.follower_infos @user.follower_infos
json.posts @json_posts
json.achievements @json_achievements
json.user_score @user_score
json.achievement_count @total_posts_count
json.follow @current_user.follows_user(@user)
json.like @current_user.check_like_in_posts(@json_posts)
json.post_ids @user_post_ids
json.achievement_ids @user_achievement_ids
json.video_urls @user_video_urls
@user.notices_has_been_showed if @user == @current_user