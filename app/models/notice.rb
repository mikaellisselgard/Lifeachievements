class Notice < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  def self.comment(comment)
    @comment_model = comment.imageable_type.constantize
    @comment_users = @comment_model.find(comment.imageable_id).comments.pluck(:user_id).uniq
    @notice = Notice.new
    @notice.user_ids = @comment_users - [comment.user_id]
    @notice.message = comment.user.name + " har kommenterat en post"
    @notice.save!
  end

end
