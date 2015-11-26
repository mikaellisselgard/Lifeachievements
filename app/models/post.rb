class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  acts_as_followable
  acts_as_follower
  belongs_to :user
  belongs_to :achievement
  has_many :likes
  has_many :comments, as: :imageable  

  before_create :check_achievement
  after_create :update_achievement, :remove_from_bucketlist
  
  validates :image, presence: true
  
  default_scope { order('created_at DESC') }

  def check_achievement
    @achievement = self.achievement
    @user = self.user
    @achievement.posts.each do |post|
      if post.user_id == @user.id
        return false
      end
    end
  end
  
  def update_achievement
    @achievement = self.achievement
    @users_with_achievement = @achievement.posts.length
    @new_score = 100 - (@users_with_achievement * 5) 
    if @new_score < 5
      @new_score = 5
    end
    @achievement.score = @new_score
    @achievement.save!
  end
  
  def remove_from_bucketlist
    @bucket_list = self.user.bucket_list
    @bucket_list.achievements.delete(self.achievement)
    @bucket_list.save!
  end
  
  def check_like(user)
    self.likes.find_by_user_id(user.id)
  end

end



