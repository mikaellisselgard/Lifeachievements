class HomeController < ApplicationController
  def index
  end
  
  def highscore
    @users = User.all
    @user_stats = []
    @users.each do |user|
      @score = []
      user.posts.each do |post|
        @score.push(post.achievement.score)
      end
      @total_score = @score.inject(:+)
      @achievements_earned = @score.length
      @user_stats.push([user, @achievements_earned, @total_score])
    end
    @user_stats = @user_stats.sort_by{|k|k[2]}.reverse
  end
  
end
