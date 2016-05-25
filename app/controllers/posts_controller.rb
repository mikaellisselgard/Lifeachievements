class PostsController < ApplicationController
before_action :set_post, except: [:index, :new, :create, :follow_index, :feature_post, :report_post]
acts_as_token_authentication_handler_for User

  def index
    # index for posts after fetching
    if params[:id] and params[:follow_ids].nil? and params[:user].nil? and params[:achievement].nil? and params[:reload].nil? and params[:new].nil?
      @posts = Post.where('id < ?', params[:id]).limit(20)
      @json_posts = Post.where('id < ?', params[:id]).limit(4)
    # index for posts pre fetching
    elsif params[:id].nil? and params[:follow_ids].nil? and params[:user].nil? and params[:achievement].nil? and params[:reload].nil? and params[:new].nil?
      @posts = Post.limit(20)
      @json_posts = Post.limit(4)
    end
    
    # index for users after fetching
    if params[:user]
      @posts = User.find(params[:user]).posts.where('id < ?', params[:id]).limit(20)
      @json_posts = User.find(params[:user]).posts.where('id < ?', params[:id]).limit(4)
    end
    
    # index for follows after fetching
    if params[:follow_ids]
      @follow_ids = params[:follow_ids]
      @follow_ids.push(current_user.id)
      @posts = Post.where('user_id IN (?)', @follow_ids).where('id < ?', params[:id]).limit(20)
      @json_posts = Post.where('user_id IN (?)', @follow_ids).where('id < ?', params[:id]).limit(4)
    end
    
    # index for achievement after fetching
    if params[:achievement]
      @posts = Achievement.find(params[:achievement]).posts.where('id < ?', params[:id]).limit(20)
      @json_posts = Achievement.find(params[:achievement]).posts.where('id < ?', params[:id]).limit(4)
    end
    
    if params[:reload]
      @post_ids = params[:reload]
      @updated_at = params[:updated_at]
      @json_posts = changed_posts(@post_ids, @updated_at)
    end
    
    if params[:new]
      @json_posts = Post.where('id > ?', params[:new]).reverse
    end
    
    @current_user = current_user
    @comment = Comment.new
  end
  
  def show
    @current_user = current_user
    @comment = Comment.new
    @comments = @post.comments.order("id DESC")
  end

  def new
    @post = Post.new
    @achievement_id = params[:achievement_id]
  end
  
  def like_post
    like = Like.create(user_id: current_user.id, post_id: @post.id)
    like.save
    if like.save
      Notice.like(like, true)
    else
      Notice.like(like, false)
      like = @post.likes.find_by_user_id(current_user.id)
      like.destroy
    end
    head :no_content
  end

  def edit
  end

  def create
    @post = current_user.posts.create(post_params)
    @post.likes_count = 0
    @post.status = 1
    @post.save!
    if @post.latitude == nil
      lat_lng = cookies[:lat_lng].split("|") rescue nil
      @post.latitude = lat_lng[0] rescue nil
      @post.longitude = lat_lng[1] rescue nil
      @post.save!
    end
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
    if @post.user_id == current_user.id || current_user.admin
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
  
  def follow_index
    # fetch all user_ids from users following current_user
    @follow_ids = current_user.follows.pluck(:followable_id)
    @follow_ids.push(current_user.id)
    @posts = Post.where('user_id IN (?)', @follow_ids).limit(20)
    @comment = Comment.new
    # check if no result for sending nil-params to index
    if @posts.length == 0
      follow_ids = 'nil'
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def feature_post
    @post = Post.find(params[:post_id])
    if @post.status == 1
      @post.update_attributes(status: 2)
    else 
      @post.update_attributes(status: 1)
    end
    redirect_to :back
  end 
  
  def report_post
    @post = Post.find(params[:post_id])
    @post.report_post(current_user)
    redirect_to :back
  end
  
  def changed_posts(post_ids, updated_at)
    changed_post_ids = []
    post_ids.each_with_index do |post_id, index|
      current_timestamp = Post.find(post_id).updated_at.strftime('%a, %d %b %Y %H:%M:%S')
      old_timestamp = updated_at[index].to_datetime.strftime('%a, %d %b %Y %H:%M:%S')
      if current_timestamp != old_timestamp 
        changed_post_ids.push(post_id)
      end
    end
    @posts = Post.where(id: changed_post_ids)
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    if params[:image] != nil || params[:video] != nil
      # For iOS requests
      params.permit(:image, :video, :achievement_id)
    else
      params.require(:post).permit(:image, :video, :user_id, :achievement_id, :status, :comments_count)
    end
  end
  
end

  
