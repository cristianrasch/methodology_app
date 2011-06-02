class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :boss_logged_in?
  
  protected

  def basic_authenticate
    authenticate_or_request_with_http_basic do |user, passwd|
      admin_user = Conf.admin_users.keys.find {|u| u == user}      
      passwd == Conf.admin_users[admin_user] if admin_user
    end
  end
  
  def ensure_boss_logged_in
    if current_user.boss?
      true
    else
      render(:text => 'Acceso denegado.', :status => :unauthorized)
      false
    end
  end
  
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  def boss_logged_in?
    current_user.boss?
  end
end
