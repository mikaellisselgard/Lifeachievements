class HomeController < ApplicationController
  
  def index
  end
  
  def highscore
    @user_week_stats = []
    @user_total_stats = []

    User.all.each do |user|
      # total highscore
      user_total_posts = user.posts.joins(:achievement)

      total_achievements_earned = user_total_posts.length
      total_score = user_total_posts.sum(:score)
      total_max_score = user_total_posts.maximum(:score)
      total_max_score_count = user_total_posts.where('achievements.score = ?', total_max_score).count
      total_likes = user_total_posts.sum(:likes_count)

      @user_total_stats.push([user,
                              total_achievements_earned, 
                              total_score,
                              total_max_score, 
                              total_max_score_count, 
                              total_likes])

      # weekly highscore
      user_week_posts = user.posts.joins(:achievement).
                          where('achievements.created_at between ? and ?',
                          Time.now.beginning_of_week, Time.now)
      
      week_achievements_earned = user_week_posts.length
      week_score = user_week_posts.sum(:score)
      week_max_score = user_week_posts.maximum(:score)
      week_max_score_count = user_week_posts.where('achievements.score = ?', week_max_score).count
      week_likes = user_week_posts.sum(:likes_count)

      @user_week_stats.push([user, 
                             week_achievements_earned, 
                             week_score, 
                             week_max_score, 
                             week_max_score_count, 
                             week_likes])
    end 
    @user_total_stats = @user_total_stats.sort_by{|k|k[2]}.reverse
    @user_week_stats = @user_week_stats.sort_by{|k|k[2]}.reverse
  end
end