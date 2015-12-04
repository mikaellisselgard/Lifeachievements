class Follow < ActiveRecord::Base
  extend ActsAsFollower::FollowerLib
  extend ActsAsFollower::FollowScopes

  belongs_to :followable, :polymorphic => true, dependent: :destroy
  belongs_to :follower,   :polymorphic => true, dependent: :destroy

  def block!
    self.update_attribute(:blocked, true)
  end

end
