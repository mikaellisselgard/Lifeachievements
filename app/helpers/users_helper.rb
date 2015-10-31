module UsersHelper
  def check_user_bucket_list(user)
    if user == current_user
      return true
    end
  end
end

