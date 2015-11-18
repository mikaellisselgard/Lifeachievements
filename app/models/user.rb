class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :achievements
  has_many :posts
  has_one :bucket_list
  has_many :medals
  has_many :likes

  after_create :set_bucket_list

  validates :name, presence: true
  
  delegate :achievements, to: :bucket_list, prefix: true
  
  def set_bucket_list
    BucketList.new({ :user_id => self.id }).save
  end
  
end
