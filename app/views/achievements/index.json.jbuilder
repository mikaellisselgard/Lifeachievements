json.array!(@json_achievements) do |achievement|
  json.extract! achievement, :id, :description, :score, :posts_count, :latest_posts, :completer_user_infos, :created_at, :updated_at
  json.url achievement_url(achievement, format: :json)
  json.bucketlist achievement.check_if_in_bucketlist(@current_user)
end
