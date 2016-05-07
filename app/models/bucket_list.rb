class BucketList < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :achievements
  
  def add_achievement(achievement)
    self.achievements << achievement unless self.achievements.include?(achievement)
    self.save!
    self.user.touch
  end
  
  def remove_achievement(achievement)
    self.achievements.destroy(achievement)
    self.user.touch
  end
  
end
