class Achievement < ActiveRecord::Base
  has_many :users, through: :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :bucket_lists
  has_many :posts, dependent: :destroy
  belongs_to :user
  
  default_scope { order('created_at DESC') }
  
  validates :description, presence: true
  
  after_create :set_score
  
  def set_score
    self.score = 100
    self.save!
  end
  
  def self.generate_new_achievements
    # first file in lib/assets/not_used/
    first_file = Dir.glob("lib/assets/not_used/*").first
    File.open(first_file) do |file|
      file.each_line do |line|
        self.new(description: line.chomp, user_id: 1).save
      end
    end
    # rename and save file in used
    File.rename first_file, "lib/assets/used/#{self.first.id}"
  end
  
  def check_if_in_bucketlist(user)
    user.bucket_list.achievements.include?(self)
  end
  
  def check_if_completed(user)
    user.achievements.include?(self)
  end

  def latest_posts
    image_urls = []
    self.posts.first(3).each do |post|
      image_urls.push(post.image_url(:thumb_achievement))
    end
    image_urls
  end 

  def completer_user_infos
    completer_user_ids = []
    completer_user_names = []
    completer_user_avatars = []
    self.posts.each do |post|
      completer_user_ids.push(post.user.id)
      completer_user_names.push(post.user.name)
      completer_user_avatars.push(post.user.avatar.url)
    end
    completer_user_infos = [completer_user_ids, completer_user_names, completer_user_avatars]
    completer_user_infos
  end
  
end
