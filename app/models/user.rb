class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader, dependent: :destroy
  acts_as_token_authenticatable
  acts_as_followable
  acts_as_follower
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts, dependent: :destroy
  has_many :achievements, through: :posts, dependent: :destroy
  has_and_belongs_to_many :notices
  has_one :bucket_list
  has_many :medals, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports
  
  after_create :set_bucket_list

  after_create :set_user_avatar
  
  delegate :achievements, to: :bucket_list, prefix: true
  
  def set_bucket_list
    self.build_bucket_list
  end
  
  def has_achievement(achievement)
    self.achievements.include? achievement
  end
  
  def set_user_avatar
    self.avatar = File.open("public/avatar.png")
    self.save!
  end
  
  def follows_user(followed_user)
    self.follows.pluck(:followable_id).include? followed_user.id
  end
  
  def follow_infos
    follow_user_names = []
    follow_user_avatars = []
    follow_user_ids = []
    self.follows.each do |follow|
      follow_user = User.find(follow.followable_id)
      follow_user_names.push(follow_user.name)
      follow_user_avatars.push(follow_user.avatar_url)
      follow_user_ids.push(follow_user.id)
    end
    [follow_user_names, follow_user_avatars, follow_user_ids]
  end

  def follower_infos
    follower_user_names = []
    follower_user_avatars = []
    follower_user_ids = []
    self.followers.each do |follower|
      follower_user = User.find(follower.id)
      follower_user_names.push(follower_user.name)
      follower_user_avatars.push(follower_user.avatar_url)
      follower_user_ids.push(follower_user.id)
    end
    [follower_user_names, follower_user_avatars, follower_user_ids]
  end

  def notice_infos
    notice_user_ids = []
    notice_user_avatars = []
    notice_messages = []
    notice_types = []
    notice_link_ids = []
    notice_seen = []
    self.notices.each do |notice|
      notice_user = User.find(notice.user_id)
      notice_user_ids.push(notice_user.id)
      notice_user_avatars.push(notice_user.avatar_url)
      notice_messages.push(notice.message)
      notice_types.push(notice.notice_type)
      notice_link_ids.push(notice.link.to_i)
      notice_seen.push(notice.seen)
    end 
    [notice_user_ids, notice_user_avatars, notice_messages, notice_types, notice_link_ids, notice_seen]
  end 
  
end