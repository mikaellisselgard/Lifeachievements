module UsersHelper

  def check_user_bucket_list
    if current_user == User.find(params[:id])
      return true # This returns true if the bucket list belongs to current user
    end
  end
end
