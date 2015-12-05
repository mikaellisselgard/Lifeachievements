module ApplicationHelper
  
  def commenter_url(id)
    commenter = controller.controller_name.singularize
    comments_path(:commenter_type => commenter, :commenter_id => id)
  end
  
  def lat_lng
    @lat_lng ||= session[:lat_lng] ||= get_geolocation_data_the_hard_way
  end
  
end
