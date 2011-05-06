class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected

  def basic_authenticate
    authenticate_or_request_with_http_basic do |user, passwd|
      admin_user = Conf.admin_users.keys.find {|u| u == user}      
      passwd == Conf.admin_users[admin_user] if admin_user
    end
  end
  
  # def after_sign_in_path_for(resource)
  #   projects_path
  # end
  
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
end
