class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery
  
  private 
    def current_tracking_list
      TrackingList.find(session[:tracking_list_id])
    rescue ActiveRecord::RecordNotFound
      tracking_list = TrackingList.create
      session[:tracking_list_id] = tracking_list.id
      tracking_list
    end
    
  protected 
   
   def authorize
     unless User.find_by_id(session[:user_id])
       redirect_to login_url, :notice => "Please log in"
     end
   end
   
 
end
