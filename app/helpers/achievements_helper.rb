module AchievementsHelper
  def already_in_bucket_list(achievement)
    if user_signed_in?
      current_user.bucket_list.achievements.include?(achievement)
    end
  end
end
