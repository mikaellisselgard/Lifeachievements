class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, counter_cache: true, touch: true
  validates_uniqueness_of :user, scope: :post
end
