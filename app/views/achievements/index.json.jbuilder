json.array!(@json_achievements) do |achievement|
  json.extract! achievement, :id, :description, :score, :posts_count, :latest_posts, :completer_user_infos
  json.url achievement_url(achievement, format: :json)
end
