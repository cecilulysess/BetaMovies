class Movie < ActiveRecord::Base
  has_many :episodes
end
