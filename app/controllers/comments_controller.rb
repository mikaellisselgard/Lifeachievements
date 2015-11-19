class CommentsController < ApplicationController
  before_filter :find_commenter

  def create
     @comment = @commenter.comments.create(params[:comments])
     @comment.comment = params[:comment][:comment]
     @comment.user_id = current_user.id
     @comment.save!
     respond_to do |format|
       format.html {redirect_to :controller => @commenter.class.to_s.pluralize.downcase, :action => :show, :id => @commenter.id}
     end
   end
  
  private

  def find_commenter
    @class = params[:commenter_type].capitalize.constantize
    @commenter = @class.find(params[:commenter_id])
  end
  
end
