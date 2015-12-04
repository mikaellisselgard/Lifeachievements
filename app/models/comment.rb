class Comment < ActiveRecord::Base
  belongs_to :imageble, polymorphic: true, dependent: :destroy
  belongs_to :user, dependent: :destroy
  
  validates :comment, presence: true
  
end
