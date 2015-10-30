class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :user
  belongs_to :achievement

  before_create :check_achievement
  after_create :update_achievement

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
    @user_id_length = @achievement.posts.length
    @new_score = 105 - (@user_id_length * 5) 
    @achievement.update_attributes(:score => @new_score)
    @achievement.save!
  end

end
