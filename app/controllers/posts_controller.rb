class PostsController < ApplicationController
before_action :set_post, only: [:show, :like_post, :unlike_post, :edit, :update, :destroy]

  def index
    # if the id params is present
    if params[:id]
      # get all records with id less than 'our last id'
      # and limit the results to 5
      @posts = Post.where('id < ?', params[:id]).limit(6)
    else
      @posts = Post.limit(6)
    end
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def show
    @comment = Comment.new
    @comments = @post.comments.order("id DESC")
  end

  def new
    @post = Post.new
    @achievement_id = params[:achievement_id]
  end
  
  def like_post
    @like = Like.create(user_id: current_user.id, post_id: @post.id)
    @like.save
    if @like.save
    else
      @like = @post.likes.find_by_user_id(current_user.id)
      @like.destroy
    end
    redirect_to :back
  end
  
  
  def edit
  end

  def create
    @user = current_user
    @post = @user.posts.create(post_params)
    @post.likes_count = 0
    @post.save!
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @post.user_id == current_user.id
      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, notice: 'No permission' }
      end
    end
  end

  private
  
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:image, :message, :user_id, :achievement_id)
  end
  
end

  
