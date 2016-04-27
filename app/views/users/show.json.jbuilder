json.extract! @user, :avatar, :email, :posts, :created_at, :updated_at
json.bucketlist @user_bucketlist_achievements
json.notices @current_user.notices
json.follow_infos @user.follow_infos