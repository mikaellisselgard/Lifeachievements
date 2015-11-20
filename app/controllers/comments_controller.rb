class CommentsController < ApplicationController
  before_filter :find_commenter
  respond_to :js, :html, :json

  def create
    @comment_id = params[:commenter_id]
    @comment = @commenter.comments.create(params[:comments])
    @comment.comment = params[:comment][:comment]
    @comment.user_id = current_user.id
    @comment.save!
    @comments = @class.find(params[:commenter_id]).comments
  end
  
  private

  def find_commenter
    @class = params[:commenter_type].capitalize.constantize
    @commenter = @class.find(params[:commenter_id])
  end
  
end
