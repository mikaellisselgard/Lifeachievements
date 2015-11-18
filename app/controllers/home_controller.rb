class HomeController < ApplicationController
  
  def index
  end
  
  def highscore
    @users = User.all
    @user_stats = []
    @users.each do |user|
      @score = []
      if user.posts.length > 0
        user.posts.each do |post|
          @score.push(post.achievement.score)
        end
      end
      if @score.length > 0
        @total_score = @score.inject(:+)
        @achievements_earned = @score.length
      else
        @total_score = 0
        @achievements_earned = 0
      end
      @user_stats.push([user, @achievements_earned, @total_score])
    end
    @user_stats = @user_stats.sort_by{|k|k[2]}.reverse
  end
  
end
