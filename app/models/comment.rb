class Comment < ActiveRecord::Base
  belongs_to :imageble, polymorphic: true
end
