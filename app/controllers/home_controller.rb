class HomeController < ApplicationController
  
  def index
  end
  
  def highscore
    @users = User.all
    @user_stats = []
    @users.each do |user|
      @likes_week = user.likes_week
      @highest_score = 0
      @highest_score_count = 0
      @score = []
      if user.posts_week.length > 0
        user.posts_week.each do |post|
          @score.push(post.achievement.score)
          if post.achievement.score > @highest_score
            @highest_score_count = 0
            @highest_score = post.achievement.score
          end
          if post.achievement.score == @highest_score
            @highest_score_count += 1
          end
        end
      end
      if @score.length > 0
        @total_score = @score.inject(:+)
        @achievements_earned = @score.length
      else
        @total_score = 0
        @achievements_earned = 0
      end
      @user_stats.push([user, @achievements_earned, @total_score, @highest_score, @highest_score_count, @likes_week])
    end
    @user_stats = @user_stats.sort_by{|k|k[2]}.reverse
  end
  
end
