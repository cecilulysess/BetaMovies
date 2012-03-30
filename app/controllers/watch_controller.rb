class WatchController < ApplicationController
  def index
    @movies = Movie.all
    @tracking_list = current_tracking_list
  end
  
  def show_episode
    
    @tracking_list = current_tracking_list
    
    
    @episode = Episode.find(params[:episode_id])
    
    @movie = Movie.find(@episode.movie_id)
    @movie_title = 
      @movie.title
    @all_episodes = Movie.find(@episode.movie_id).episodes
    tracking_list = current_tracking_list
    tracking_item = tracking_list.find_movie(@episode.movie_id)
    if tracking_item
      tracking_item.last_watched_episode_id = @episode.id
      tracking_item.save
    end
  end
end
