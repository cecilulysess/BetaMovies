class WatchController < ApplicationController
  skip_before_filter :authorize
  
  def index
    # @movies = Movie.find(:all, :limit=> 10)
    @movies = Movie.paginate(:page => params[:page], :order => 'last_updated desc',
              :per_page => 10)
    @tracking_list = current_tracking_list
    
    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
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
