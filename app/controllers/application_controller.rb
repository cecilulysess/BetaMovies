class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private 
    def current_tracking_list
      TrackingList.find(session[:tracking_list_id])
    rescue ActiveRecord::RecordNotFound
      tracking_list = TrackingList.create
      session[:tracking_list_id] = tracking_list.id
      tracking_list
    end
end
