class Notice < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  default_scope { order('created_at DESC') }
  
  def self.commenters(comment)
    # notice for users who commented same post
    @comment_model = comment.imageable_type.constantize
    @object = @comment_model.find(comment.imageable_id)
    @comment_users = @object.comments.pluck(:user_id).uniq
    @commenters_notice = Notice.new
    @commenters_notice.user_ids = @comment_users - [comment.user_id, @object.user_id]
    @commenters_notice.user_id = comment.user_id
    @commenters_notice.link = comment.imageable_id
    @commenters_notice.message = comment.imageable_type.constantize
    @commenters_notice.save
    if @object.user_id != comment.user_id
      @post_notice = Notice.new
      @post_notice.user_ids = @object.user_id
      @post_notice.user_id = comment.user_id
      @post_notice.link = comment.imageable_id
      @post_notice.message = "Comment"
      @post_notice.save
    end 
  end
  
  def self.like(like, bool)
    if like.user_id != like.post.user_id
      @like_notice = Notice.new
      @like_notice.user_ids = [like.post.user_id]
      @like_notice.user_id = like.user_id
      @like_notice.link = like.post.id
      if bool
        @like_notice.message = "Like"
      else 
        @like_notice.message = "Unlike"
      end
      @like_notice.save
    end
  end
  
  def self.follow(follower, following, bool)
    @follow_notice = Notice.new
    @follow_notice.user_ids = [following.id]
    @follow_notice.user_id = follower.id
    @follow_notice.link = follower.id
    if bool
      @follow_notice.message = "Follow"
    else
      @follow_notice.message = "Unfollow"
    end
    @follow_notice.save
  end
  
  
end
