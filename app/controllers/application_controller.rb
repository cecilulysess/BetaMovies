class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user
  
  protect_from_forgery
  
  protected 
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end
  
  def authenticate
    unless current_user
      flash[:notice] = "Your're not logged in captain."
      redirect_to new_user_session_path
      return false
    end
  end
end
