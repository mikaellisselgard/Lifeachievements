class UsersController < ApplicationController
  autocomplete :user, :name, full: true
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_user_id, only: [:follow, :unfollow, :noticed, :tip]

  before_filter :authenticate_user! 

  def index
    @users = User.all
  end
  
  def show
    @posts = @user.posts.limit(20)
    
    @total_achievements_count = Achievement.count
    @total_posts_count = @user.posts.count

    @week_achievements_count = Achievement.where(created_at: Time.now.beginning_of_week..Time.now).count
    @week_posts_count = @user.posts.joins(:achievement).
                          where('achievements.created_at between ? and ?',
                          Time.now.beginning_of_week, Time.now).count

    @comment = Comment.new
    @achievements = Achievement.all
    respond_to do |format|
      format.html
      format.js
    end
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
  
  def follow
    current_user.follow(@user)
    Notice.follow(current_user, @user, true)
    redirect_to :back
  end
  
  def unfollow
    current_user.stop_following(@user)
    Notice.follow(current_user, @user, false)
    redirect_to :back
  end
  
  def tip
    achievement_id = params[:achievement]
    Notice.tip(current_user, @user, achievement_id)
    redirect_to :back
  end
  
  def noticed
    @user.notices.where(seen: nil).update_all(seen: Time.now)
    redirect_to :back
  end
    
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_user_id
    @user = User.find(params[:user_id])
  end
  
  def user_params
    params.require(:user).permit(:avatar)
  end
  
end
