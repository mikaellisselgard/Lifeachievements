json.extract! @achievement, :id, :description, :score, :created_at, :updated_at, :posts
json.completer_infos @achievement.completer_user_infos
json.bucketlist @achievement.check_if_in_bucketlist(@current_user)
