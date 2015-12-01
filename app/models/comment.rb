class Comment < ActiveRecord::Base
  belongs_to :imageble, polymorphic: true
  belongs_to :user
  
  validates :comment, presence: true
  
end
