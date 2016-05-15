class Notice < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  default_scope { order('created_at DESC') }
  
  def self.commenters(comment) 
    # find specific commented record from model
    commented_record = comment.imageable_type.constantize.find(comment.imageable_id)
    comment_users = commented_record.comments.pluck(:user_id).uniq
    
    # notice for users who commented same record
    Notice.new({
      # subtract comment creator and record creator
      user_ids: comment_users - [comment.user_id, commented_record.user_id],
      user_id: comment.user_id,
      link: commented_record.id,
      message: comment.user.name + " har kommenterat samma inlägg som dig",
      notice_type: "comment"
    }).save
    
    # notice for owner of the record
    if commented_record.user_id != comment.user_id
      Notice.new({
        user_ids: commented_record.user_id,
        user_id: comment.user_id,
        link: commented_record.id,
        message: comment.user.name + " har kommenterat ditt inlägg",
        notice_type: "comment"
      }).save
    end 
  end
  
  def self.like(like, liked)
    if like.user != like.post.user
      like_notice = Notice.new({
        user_ids: [like.post.user_id],
        user_id: like.user_id,
        link: like.post.id,
        notice_type: "like"
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
      link: "follow",
      notice_type: "follow"
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
      message: medal_user.name + " vann medalj för " + type,
      notice_type: "medal"
    }).save
  end
  
  def self.tip(tip_from, tip_to, tip_id)
    Notice.new({
      user_ids: tip_to.id,
      user_id: tip_from.id,
      link: tip_id,
      message: tip_from.name + " vill tipsa dig om ett uppdrag",
      notice_type: "tip"
    }).save
  end
  
end


