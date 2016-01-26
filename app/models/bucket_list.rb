class BucketList < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :achievements

  def add_achievement(achievement)
    achievements << achievement unless achievements.include?(achievement)
    self.save!
  end

  def remove_achievement(achievement)
    achievements.destroy(achievement)
  end
end
