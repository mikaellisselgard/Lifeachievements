class HomeController < ApplicationController
  def index
  end

  def highscore
    @total_achievements_count = Achievement.count

    @user_total_stats = []

    User.all.each do |user|
      # total highscore
      user_total_posts = user.posts.joins(:achievement)

      total_achievements_earned = user_total_posts.length
      total_score = user_total_posts.sum(:score)
      total_max_score = user_total_posts.maximum(:score)
      total_max_score_count = user_total_posts.where("achievements.score = ?", total_max_score).count
      total_likes = user_total_posts.sum(:likes_count)

      @user_total_stats.push([user,
                              total_achievements_earned,
                              total_score,
                              total_max_score,
                              total_max_score_count,
                              total_likes])
    end
    @user_total_stats = @user_total_stats.sort_by { |k| k[2] }.reverse.first(12)
  end
end
