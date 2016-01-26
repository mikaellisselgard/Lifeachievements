class AchievementsController < ApplicationController
  before_action :set_achievement, only: [:show, :edit, :update, :destroy]

  autocomplete :achievement, :description, full: true

  before_action :authenticate_user!
  # GET /achievements
  # GET /achievements.json
  def index
    @achievements = Achievement.all
  end

  # GET /achievements/1
  # GET /achievements/1.json
  def show
    @posts = @achievement.posts.limit(20)
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
        format.html do
          redirect_to @achievement,
                      notice: "Achievement was successfully created."
        end
        format.json { render :show, status: :created, location: @achievement }
      else
        format.html { render :new }
        format.json do
          render json: @achievement.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /achievements/1
  # PATCH/PUT /achievements/1.json
  def update
    respond_to do |format|
      if @achievement.update(achievement_params)
        format.html do
          redirect_to @achievement,
                      notice: "Achievement was successfully updated."
        end
        format.json { render :show, status: :ok, location: @achievement }
      else
        format.html { render :edit }
        format.json do
          render json: @achievement.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /achievements/1
  # DELETE /achievements/1.json
  def destroy
    @achievement.destroy
    respond_to do |format|
      format.html do
        redirect_to achievements_url,
                    notice: "Achievement was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_achievement
    @achievement = Achievement.find(params[:id])
  end

  def achievement_params
    params.require(:achievement).permit(:description, :score, category_ids: [])
  end
end
