class BucketList < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :achievements
  
  def add_achievement(achievement)
    self.achievements << achievement
    self.save!
  end
  
  def remove_achievement(achievement)
    self.achievements.delete(achievement)
    self.save!
  end
  
end
