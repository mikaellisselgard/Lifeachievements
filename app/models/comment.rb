class Comment < ActiveRecord::Base
  belongs_to :imageble, polymorphic: true
  belongs_to :user
  belongs_to :post, counter_cache: true, touch: true
  
  validates :comment, presence: true
  
end
