class UsersController < ApplicationController
  autocomplete :user, :name, full: true
  before_action :set_user, only: [:show, :edit]
  before_action :set_user_id, only: [:follow, :unfollow, :noticed, :tip]
  acts_as_token_authentication_handler_for User

  def index
    @users = User.all
  end
  
  def show
    @posts = @user.posts.limit(20)
    @json_posts = @user.posts.limit(4)
    @json_achievements = Achievement.where(id: @json_posts.pluck(:achievement_id))
    @user_score = @user.posts.joins(:achievement).sum(:score)
  
    @total_achievements_count = Achievement.count
    @total_posts_count = @user.posts.count

    @week_achievements_count = Achievement.where(created_at: Time.now.beginning_of_week..Time.now).count
    @week_posts_count = @user.posts.joins(:achievement).
                          where('achievements.created_at between ? and ?',
                          Time.now.beginning_of_week, Time.now).count

    @comment = Comment.new
    @achievements = Achievement.all
    @current_user = current_user
    @user_bucketlist_achievements = @user.bucket_list.achievements
    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end
  
  def edit
  end
  
  def update
    @user = current_user
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
  
  def change_password
    if current_user.valid_password? params[:current_password]
      current_user.reset_password(params[:password], params[:password_confirmation])
      @result = true
    else
      @result = false
    end
  end
    
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_user_id
    @user = User.find(params[:user_id])
  end
  
  def user_params
    if params[:avatar] != nil
      # For iOS requests
      params.permit(:name, :avatar, :current_password, :password, :password_confirmation)
    else
      params.require(:user).permit(:name, :avatar, :current_password, :password, :hide, :share_gps)
    end
  end
  
end
