module ApplicationHelper
  def commenter_url(id)
    commenter = controller.controller_name.singularize
    comments_path(commenter_type: commenter, commenter_id: id)
  end

  def lat_lng
    @lat_lng ||= session[:lat_lng] ||= get_geolocation_data_the_hard_way
  end

  def icon(icon)
    "<i class='#{icon}'></i>".html_safe
  end

  def number_format_k(value)
    number_to_human(value, precision: 1, separator: ",", significant: false, format: "%n%u", units: { thousand: "K" })
  end
end
