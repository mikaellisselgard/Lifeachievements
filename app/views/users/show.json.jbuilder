json.extract! @user, :avatar, :email, :posts, :created_at, :updated_at
json.bucketlist @user_bucketlist_achievements
json.notice_infos @current_user.notice_infos
json.follow_infos @user.follow_infos