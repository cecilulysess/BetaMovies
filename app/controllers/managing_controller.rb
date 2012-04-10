class ManagingController < ApplicationController
  def index
    unless User.find_by_id(session[:user_id]).privilege > 0
       redirect_to login_url, :alert  => "Require administrator privilege"
     end
    @total_tracking_items = current_tracking_list.tracking_items.count
  end
end
