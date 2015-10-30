class UsersController < ApplicationController

  autocomplete :user, :name, full: true
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
end
