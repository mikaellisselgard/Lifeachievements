class Achievement < ActiveRecord::Base
  has_many :users, through: :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :bucket_lists
  has_many :posts, dependent: :destroy
  belongs_to :user
  
  default_scope { order('created_at DESC') }
  
  validates :description, presence: true
  
  after_create :set_score
  after_create :create_search_result

  before_destroy :remove_search_result
  before_destroy :remove_notice_links
  
  def set_score
    self.score = 100
    self.save!
  end

  def create_search_result
    SearchResult.create(record_string: description, record_id: id, record_type: 'achievement', record_image: '/achievement_icon_blue.png')
  end

  def remove_search_result 
    SearchResult.where(record_type: 'achievement').find_by_record_id(id).destroy
  end
  
  def remove_notice_links
    Notice.where(notice_type: 'tip').where(link: id).destroy_all
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
  
  def check_user_post(user)
    post = self.posts.find_by_user_id(user.id)
    if post
      post.id
    else
      0
    end
  end

  def latest_posts
    image_urls = []
    post_ids = []
    self.posts.first(3).each do |post|
      image_urls.push(post.image_url(:thumb_achievement))
      post_ids.push(post.id)
    end
    [image_urls, post_ids]
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
