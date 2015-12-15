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
  
  after_create :set_bucket_list

  before_create :set_user_name
  
  delegate :achievements, to: :bucket_list, prefix: true
  
  def set_bucket_list
    self.build_bucket_list
  end
  
  def has_achievement(achievement)
    self.achievements.include? achievement
  end

  def set_user_name 
    self.name = self.email[/[^@]+/]
    if User.find_by_name(self.name)
      self.name = self.name + (1..9).sort_by{rand}.last(4).join("")
    end 
  end 

end