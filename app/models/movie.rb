class Movie < ActiveRecord::Base
  validates :title, :description, :image_url, :presence => true
  validates :image_url, :format => {
    :with   => %r{\.(gif|jpg|jpeg|png)$}i,
    :message => 'Must be a URL for GIF, JPG or PNG'
  }
end
