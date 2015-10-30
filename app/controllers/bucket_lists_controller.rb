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
  
  def remove_achievement
    @user_bucket_id = current_user.bucket_list.id
    @achievement = Achievement.find(params[:id])
    @achievement_bucket_ids = @achievement.bucket_list_ids
    @achievement_bucket_ids.delete(@user_bucket_id)
    @achievement.update_attributes(:bucket_list_ids => @achievement_bucket_ids)
    @achievement.save
    redirect_to :back
  end

end
