class BucketListsController < ApplicationController
  
  def show
    @bucket_list = BucketList.find(params[:id])
    @achievements = @bucket_list.achievements.reverse
  end
  
  def add_achievement
    @user_bucket_list = current_user.bucket_list
    @achievement = Achievement.find(params[:id])
    @user_bucket_list.add_achievement(@achievement)
    respond_to do |format|
      format.js
    end
  end

  #Lets user remove achievement from bucket list
  def remove_bucket_list_item
    @user_bucket_list = current_user.bucket_list
    @achievement = Achievement.find(params[:id])
    @user_bucket_list.remove_achievement(@achievement)
    respond_to do |format|
      format.js
    end
  end

end
