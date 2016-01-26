module UsersHelper
  def check_user_bucket_list(user)
    return true if user == current_user
  end
end
