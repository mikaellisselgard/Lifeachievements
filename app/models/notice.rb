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
  
  def self.like(like, liked)
    if like.user != like.post.user
      like_notice = Notice.new({
        user_ids: [like.post.user_id],
        user_id: like.user_id,
        link: like.post.id
      })
      if liked
        like_notice.message = like.user.name + " gillar ett av dina inlägg"
      else 
        like_notice.message = like.user.name + " slutade gilla ett av dina inlägg"
      end
      like_notice.save
    end
  end
  
  def self.follow(follower, following, follow)
    follow_user = User.find(follower)
    follow_notice = Notice.new({
      user_ids: [following.id],
      user_id: follower.id,
      link: "follow"
    })
    if follow
      follow_notice.message = follow_user.name + " följer nu dig"
    else
      follow_notice.message = follow_user.name + " har slutat följa dig"
    end
    follow_notice.save
  end
  
  def self.medal(user, type)
    medal_user = User.find(user)
    recievers = User.all.pluck(:id)
    Notice.new({
      user_ids: recievers,
      user_id: medal_user.id,
      message: medal_user.name + " vann medalj för " + type
    }).save
  end
  
end


