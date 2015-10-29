json.array!(@achievements) do |achievement|
  json.extract! achievement, :id, :description, :score
  json.url achievement_url(achievement, format: :json)
end
