class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  acts_as_followable
  acts_as_follower
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts
  has_many :achievements, through: :posts
  has_and_belongs_to_many :notices
  has_one :bucket_list
  has_many :medals
  has_many :likes
  has_many :comments

  after_create :set_bucket_list

  validates :name, presence: true
  
  delegate :achievements, to: :bucket_list, prefix: true
  
  def set_bucket_list
    self.build_bucket_list
  end
  
  def posts_week
    self.posts.where(:created_at => Time.now.beginning_of_week..Time.now.end_of_week)
  end
  
  def likes_week
    self.posts.where(:created_at => Time.now.beginning_of_week..Time.now.end_of_week).sum(:likes_count)
  end

end
