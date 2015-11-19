class Achievement < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :bucket_lists
  has_many :posts
  has_many :comments, as: :imageable
end
