class Comment < ActiveRecord::Base
  belongs_to :imageble, polymorphic: true
  belongs_to :user
  belongs_to :post, counter_cache: true
  
  validates :comment, presence: true
  
  after_create :touch_post
  
  def touch_post
    Post.find(self.imageable_id).touch
  end
  
end
