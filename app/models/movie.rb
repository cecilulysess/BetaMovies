class Movie < ActiveRecord::Base
  # a movie is able to have zero episode given it has not started yet
  has_many :episodes
  has_many :tracking_items
  default_scope :order => 'last_updated'
  
  before_destroy :ensure_not_referenced_by_any_tracking_item
  
  validates :title, :description, :image_url, :last_updated, :presence => true
  validates :image_url, :format => {
    :with   => %r{\.(gif|jpg|jpeg|png)$}i,
    :message => 'Must be a URL for GIF, JPG or PNG'
  }
  
  
  #ensure no tracking item link to this movie
  def ensure_not_referenced_by_any_tracking_item
    if :tracking_items.count.zero?
      return true
    else
      errors[:base] << "Some TrackingItem contains this movie"
      return false
    end
  end
end
