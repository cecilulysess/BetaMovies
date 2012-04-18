class EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:id])
    @movie = @episode.movie
  end
  
  def new
    # @movie = Movie.find(params[:movie_id])
    @episode = Episode.new
    @episode.movie_id = params[:movie_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @episode }
    end
  end

  def create
    @episode = Episode.new(params[:episode])
    @episode.movie_id = params[:movie_id]
    respond_to do |format|
      if @episode.save
        flash[:notice] = "Episode created"
        format.html { redirect_to edit_movie_path(@episode.movie_id), notice: 'Movie was successfully created.' }
        format.json { render json: @episode, status: :created, location: @episode }
      else
        format.html { render action: "new" }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end
end
