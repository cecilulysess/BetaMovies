class TrackingItem < ActiveRecord::Base
  has_one :last_watched_episode
  belongs_to :tracking_list
  belongs_to :movie
end
