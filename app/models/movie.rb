class Movie < ActiveRecord::Base
  # a movie is able to have zero episode given it has not started yet
  has_many :episode
  default_scope :order => 'last_updated'
  validates :title, :description, :image_url, :last_updated, :presence => true
  validates :image_url, :format => {
    :with   => %r{\.(gif|jpg|jpeg|png)$}i,
    :message => 'Must be a URL for GIF, JPG or PNG'
  }
  
end
