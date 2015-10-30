class UsersController < ApplicationController

  autocomplete :user, :name, full: true
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])

    @user_bucket_list = @user.bucket_list.achievements

    #Check if bucket list belongs to current user
    @check_user_bucket_list = false
    if current_user == @user
      @check_user_bucket_list = true
    end

  end
  
end
