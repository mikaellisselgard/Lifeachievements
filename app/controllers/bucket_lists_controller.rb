class BucketListsController < ApplicationController
  acts_as_token_authentication_handler_for User
  
  def add_bucket_list_item
    @user_bucket_list = current_user.bucket_list
    @achievement = Achievement.find(params[:id])
    @user_bucket_list.add_achievement(@achievement)
    respond_to do |format|
      format.js
    end
  end

  def remove_bucket_list_item
    @user_bucket_list = current_user.bucket_list
    @achievement = Achievement.find(params[:id])
    @user_bucket_list.remove_achievement(@achievement)
    respond_to do |format|
      format.js
    end
  end

end
