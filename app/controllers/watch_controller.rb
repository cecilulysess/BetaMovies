class WatchController < ApplicationController
  def index
    @movies = Movie.all
  end
  
  def show_episode(episode_id)
    @episode = Episode.find(episode_id)
    @all_episodes = Movie.find(@episode.movie_id).episode
  end
end
