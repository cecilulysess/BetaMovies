class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user, :user_signed_in?
  before_filter :authenticate_user!
  protect_from_forgery
  

  
  def authenticate
    unless current_user
      flash[:notice] = "Your're not logged in captain."
      redirect_to new_user_session_path
      return false
    end
  end
end
