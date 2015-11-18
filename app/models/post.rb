class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :achievement

  before_create :check_achievement
  after_create :update_achievement, :remove_from_bucketlist
  
  validates :image, presence: true

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

end



