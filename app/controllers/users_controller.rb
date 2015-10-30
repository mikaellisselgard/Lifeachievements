class UsersController < ApplicationController
  autocomplete :user, :name, full: true
  before_action :set_user, only: [:show, :edit, :update]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
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
