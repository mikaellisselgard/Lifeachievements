class Follow < ActiveRecord::Base
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true
  
  after_create :touch_users
  before_destroy :touch_users

  def block!
    self.update_attribute(:blocked, true)
  end
  
  def touch_users
    User.where(id: [self.followable_id, self.follower_id]).update_all(updated_at: Time.now)
  end

end
