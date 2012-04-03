class ManagingController < ApplicationController
  def index
    @total_tracking_items = current_tracking_list.tracking_items.count
  end
end
