# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do
  @achievement = Achievement.create(score: 100, description: Faker::Lorem.word, )
  @achievement.posts.create(image: Faker::Avatar.image, message: Faker::Lorem.sentence, user_id: 1, height: 300, width: 300, likes_count: 0)
end