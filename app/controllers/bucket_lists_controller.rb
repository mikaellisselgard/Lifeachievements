class BucketListsController < ApplicationController
  
  def show
    @bucket_list = BucketList.find(params[:id])
  end
  
  def add_achievement
    @user_bucket_id = current_user.bucket_list.id
    @achievement = Achievement.find(params[:id])
    @achievement_bucket_ids = @achievement.bucket_list_ids
    @achievement_bucket_ids.push(@user_bucket_id)
    @achievement.update_attributes(:bucket_list_ids => @achievement_bucket_ids)
    @achievement.save
    respond_to do |format|
      format.js
    end
  end

  #Auto remove achievement from bucket list when completed
  def remove_achievement
    @user_bucket_id = current_user.bucket_list.id
    @achievement = Achievement.find(params[:id])
    @achievement_bucket_ids = @achievement.bucket_list_ids
    @achievement_bucket_ids.delete(@user_bucket_id)
    @achievement.update_attributes(:bucket_list_ids => @achievement_bucket_ids)
    @achievement.save
    redirect_to :back
  end

  #Lets user remove achievement from bucket list
  def remove_bucket_list_item
    @user = current_user # Extra line to be able to pass @user object in bucket_list partial
    @bucket_list = @user.bucket_list
    @achievements = @bucket_list.achievements
    @achievement = Achievement.find(params[:id])
    @achievements.delete(@achievement)
    @bucket_list.save
    respond_to do |format|
      format.js
    end
  end

end
