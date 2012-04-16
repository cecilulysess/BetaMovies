class EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:episode_id])
  end
end
