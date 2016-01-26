# This file should contain all the record creation needed to seed the database
# with its default values. The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if User.all.empty?
  User.create! name: "Admin", email: "admin@la.se", password: "1585otols"

  30.times do
    User.create! name: Faker::Name.first_name,
                 email: Faker::Internet.email,
                 password: "1585otols"
  end

  50.times do
    Achievement.create! score: 100, description: Faker::Lorem.word
  end

  User.all.each do |user|
    user.set_bucket_list.save!
    Achievement.all.each do |achievement|
      next unless rand(10) > 8
      image = File.open(File.join(Rails.root, "/public/seed/bigbets.png"))
      Post.create! user_id: user.id,
                   achievement_id: achievement.id,
                   image: image
    end
    User.all.each do |follows|
      user.follow(follows) if rand(10) > 8
    end
  end

  Post.all.each do |post|
    rand(10).times do
      Comment.create comment: Faker::Lorem.sentence,
                     imageable_id: post.id,
                     imageable_type: "Post",
                     user_id: rand(1..30)
    end
  end

  User.all.each do |user|
    Post.all.each do |post|
      Like.create(user_id: user.id, post_id: post.id) if rand(10) > 8
    end
  end

end
