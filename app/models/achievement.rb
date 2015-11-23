class Achievement < ActiveRecord::Base
  has_many :users, through: :posts
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :bucket_lists
  has_many :posts
  has_many :comments, as: :imageable
  
  default_scope { order('created_at DESC') }
  
end
