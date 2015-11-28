module ApplicationHelper
  
  def commenter_url(id)
    commenter = controller.controller_name.singularize
    comments_path(:commenter_type => commenter, :commenter_id => id)
  end

  def already_in_bucket_list(achievement)
    if current_user.bucket_list.achievements.include?(achievement)
    	true
    end 
  end
end
