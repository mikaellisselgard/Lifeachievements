class AchievementsController < ApplicationController
  before_action :set_achievement, only: [:show, :edit, :update, :destroy]

  acts_as_token_authentication_handler_for User

  # GET /achievements
  # GET /achievements.json
  def index
    if params[:achievements]
      @achievements = Achievement.where('id < ?', params[:achievements]).limit(20)
      @json_achievements = Achievement.where('id < ?', params[:achievements]).limit(4)
    else
      @achievements = Achievement.limit(20)
      @json_achievements = Achievement.limit(4)
    end
    @current_user = current_user
    
    if params[:reload]
      achievement_ids = params[:reload]
      updated_at = params[:updated_at]
      @json_achievements = changed_achievements(achievement_ids, updated_at)
    end
    
    if params[:new]
      @json_achievements = Achievement.where('id > ?', params[:new]).reverse
    end

    @post = Post.new  
  end

  # GET /achievements/1
  # GET /achievements/1.json
  def show
    @current_user = current_user
    @posts = @achievement.posts.limit(20)
    @comment = Comment.new
    @post = Post.new
  end

  def show_bucket_list
    @achievements = current_user.bucket_list.achievements.limit(20)
    @post = Post.new
  end

  # GET /achievements/new
  def new
    @achievement = Achievement.new
    @categories = Category.all
  end

  # GET /achievements/1/edit
  def edit
    @categories = Category.all
  end

  # POST /achievements
  # POST /achievements.json
  def create
    @achievement = Achievement.new(achievement_params)
    respond_to do |format|
      if @achievement.save
        format.html { redirect_to @achievement, notice: 'Achievement was successfully created.' }
        format.json { render :show, status: :created, location: @achievement }
      else
        format.html { render :new }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /achievements/1
  # PATCH/PUT /achievements/1.json
  def update
    respond_to do |format|
      if @achievement.update(achievement_params)
        format.html { redirect_to @achievement, notice: 'Achievement was successfully updated.' }
        format.json { render :show, status: :ok, location: @achievement }
      else
        format.html { render :edit }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /achievements/1
  # DELETE /achievements/1.json
  def destroy
    @achievement.destroy
    respond_to do |format|
      format.html { redirect_to achievements_url, notice: 'Achievement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def changed_achievements(achievement_ids, updated_at)
    changed_achievement_ids = []
    achievement_ids.each_with_index do |achievement_id, index|
      current_timestamp = Achievement.find(achievement_id).updated_at.strftime('%a, %d %b %Y %H:%M:%S')
      old_timestamp = updated_at[index].to_datetime.strftime('%a, %d %b %Y %H:%M:%S')
      if current_timestamp != old_timestamp 
        changed_achievement_ids.push(achievement_id)
      end
    end
    achievements = Achievement.where(id: changed_achievement_ids)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_achievement
      @achievement = Achievement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def achievement_params
      params.require(:achievement).permit(:description, :score, :posts_count, category_ids: [])
    end
end
