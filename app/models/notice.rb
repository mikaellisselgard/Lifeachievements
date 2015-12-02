class Notice < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  default_scope { order('created_at DESC') }
  
  def self.commenters(comment)
    # notice for users who commented same post
    @com_user = User.find(comment.user_id)
    @comment_model = comment.imageable_type.constantize
    @object = @comment_model.find(comment.imageable_id)
    @comment_users = @object.comments.pluck(:user_id).uniq
    @commenters_notice = Notice.new
    # NOTE: Would be better if named recievers
    @commenters_notice.user_ids = @comment_users - [comment.user_id, @object.user_id]
    # NOTE: Maybe rename to owner or creator
    @commenters_notice.user_id = comment.user_id
    # NOTE: Should be polymorphic
    #        link should be renamed to `link_id`
    #        you should also add an `link_type` column that includes the link class like "User" or "Post" or something else
    #        Then you can whrite it like `@commenters_notice.link = @object`
    @commenters_notice.link = @object.id
    @commenters_notice.message = @com_user.name + " har kommenterat samma inlägg som dig" 
    @commenters_notice.save
    if @object.user_id != comment.user_id
      @post_notice = Notice.new
      @post_notice.user_ids = @object.user_id
      @post_notice.user_id = comment.user_id
      @post_notice.link = @object.id
      @post_notice.message = @com_user.name + " har kommenterat ditt inlägg"
      @post_notice.save
    end 
  end
  
  def self.like(like, bool)
    @like_user = User.find(like.user_id)
    if like.user_id != like.post.user_id
      @like_notice = Notice.new
      @like_notice.user_ids = [like.post.user_id]
      @like_notice.user_id = like.user_id
      @like_notice.link = like.post.id
      if bool
        @like_notice.message = @like_user.name + " gillar ett av dina inlägg"
      else 
        @like_notice.message = @like_user.name + " slutade gilla ett av dina inlägg"
      end
      @like_notice.save
    end
  end
  
  def self.follow(follower, following, bool)
    @follow_user = User.find(follower.id)
    @follow_notice = Notice.new
    @follow_notice.user_ids = [following.id]
    @follow_notice.user_id = follower.id
    @follow_notice.link = "follow"
    if bool
      @follow_notice.message = @follow_user.name + " följer nu dig"
    else
      @follow_notice.message = @follow_user.name + " har slutat följa dig"
    end
    @follow_notice.save
  end
  
  def self.medal(user, type)
    @medal_user = User.find(user)
    @all_user_ids = User.all.pluck(:id)
    @medal_notice = Notice.new
    @medal_notice.user_ids = @all_user_ids
    @medal_notice.user_id = user
    @medal_notice.message = @medal_user.name + " vann medalj för " + type
    @medal_notice.save
  end
  
end
