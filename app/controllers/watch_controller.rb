class WatchController < ApplicationController
  def index
    @movies = Movie.all
  end
  
  def show_episode
    @episode = Episode.find(params[:episode_id])
    
    @movie = Movie.find(@episode.movie_id)
    @movie_title = 
      @movie.title
    @all_episodes = Movie.find(@episode.movie_id).episode
    
  end
end
