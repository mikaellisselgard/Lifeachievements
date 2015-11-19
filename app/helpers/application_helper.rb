module ApplicationHelper
  
  def commenter_url
    commenter = controller.controller_name.singularize
    comments_path(:commenter_type => commenter, :commenter_id => controller.instance_variable_get("@#{commenter}").id)
  end
  
end
