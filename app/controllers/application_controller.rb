# coding: utf-8
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
  
  def authenticate_admin
    unless current_user && current_user.privilege_level > 0
      flash[:notice] = "只有管理员才有权限进行修改操作"
      redirect_to movies_path
      return false
    end
  end
end
