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

  after_create :set_user_name
  
  delegate :achievements, to: :bucket_list, prefix: true
  
  def set_bucket_list
    self.build_bucket_list
  end
  
  def has_achievement(achievement)
    self.achievements.include? achievement
  end

  def set_user_name 
    self.name = email[/[^@]+/]
    self.save!
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

  def notice_infos
    notice_user_ids = []
    notice_user_avatars = []
    notice_messages = []
    self.notices.each do |notice|
      notice_user = User.find(notice.user_id)
      notice_user_ids.push(notice_user.id)
      notice_user_avatars.push(notice_user.avatar_url)
      notice_messages.push(notice.message)
    end 
    [notice_user_ids, notice_user_avatars, notice_messages]
  end 
  
end