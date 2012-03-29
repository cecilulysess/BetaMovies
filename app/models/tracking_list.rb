class TrackingList < ActiveRecord::Base
  has_many :tracking_items, :dependent => :destroy
  
  def add_movie(movie_id)
    current_movie = tracking_items.where(:movie_id => movie_id).first
    if current_movie
      return nil
    else
      current_movie = TrackingItem.new(:movie_id => movie_id,
       :tracking_list_id => self.id)
       self.quantity += 1
       tracking_items << current_movie
       self.save
    end
    current_movie
  end
end
