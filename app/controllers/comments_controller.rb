class CommentsController < ApplicationController
  before_filter :find_commenter
  respond_to :js, :html, :json
  acts_as_token_authentication_handler_for User

  before_filter :authenticate_user! 

  def create
    comment = @commenter.comments.new({ 
      comment: params[:comment][:comment],
      user_id: current_user.id
    })
    comment.save!

    Notice.commenters(comment)

    # pass to create.js.erb
    @comment_id = params[:commenter_id]
    # pass to list.html.erb
    @comments = @class.find(params[:commenter_id]).comments
  end
  
  private

  def find_commenter
    @class = params[:commenter_type].capitalize.constantize
    @commenter = @class.find(params[:commenter_id])
  end
  
end
