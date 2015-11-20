module ApplicationHelper
  
  def commenter_url(id)
    commenter = controller.controller_name.singularize
    comments_path(:commenter_type => commenter, :commenter_id => id)
  end
  
end
