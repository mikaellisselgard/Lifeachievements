class User < ActiveRecord::Base
  has_and_belongs_to_many :achievements
  has_many :posts
  has_one :bucket_list
end
