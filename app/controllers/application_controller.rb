class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :find_notices
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :verify_authenticity_token

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end
  
  def find_notices
    if user_signed_in?
      @notices = current_user.notices.where(seen: nil).limit(10)
    end
  end
  
end
