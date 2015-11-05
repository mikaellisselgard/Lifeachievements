class UsersController < ApplicationController
  autocomplete :user, :name, full: true
  before_action :set_user, only: [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def show
    # user_find_by_id for updating and editing, find_by_name for finding users in search
    if params[:id] == current_user.id.to_s
      @user = User.find(params[:id])
    else 
      @user = User.find_by_name(params[:id])
    end
    #@bucket_list = @user.bucket_list
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:avatar)
  end
  
end
