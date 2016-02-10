class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader, dependent: :destroy
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

  before_save :set_user_name
  
  delegate :achievements, to: :bucket_list, prefix: true
  
  def set_bucket_list
    self.build_bucket_list
  end
  
  def has_achievement(achievement)
    self.achievements.include? achievement
  end

  def set_user_name 
    if User.where.not(id: id).find_by_name(email[/[^@]+/])
      self.name = email[/[^@]+/] + id.to_s
    else
      self.name = email[/[^@]+/] 
    end 
  end 

end