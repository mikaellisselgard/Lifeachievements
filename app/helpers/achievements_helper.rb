module AchievementsHelper

	def already_in_bucket_list(achievement)
	    if current_user.bucket_list.achievements.include?(achievement)
	    	true
	    end 
  	end

end
