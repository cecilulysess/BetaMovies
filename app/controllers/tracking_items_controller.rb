class TrackingItemsController < ApplicationController
  # GET /tracking_items
  # GET /tracking_items.json
  def index
    @tracking_items = TrackingItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracking_items }
    end
  end

  # GET /tracking_items/1
  # GET /tracking_items/1.json
  def show
    @tracking_item = TrackingItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tracking_item }
    end
  end

  # GET /tracking_items/new
  # GET /tracking_items/new.json
  def new
    @tracking_item = TrackingItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tracking_item }
    end
  end

  # GET /tracking_items/1/edit
  def edit
    @tracking_item = TrackingItem.find(params[:id])
  end

  # POST /tracking_items
  # POST /tracking_items.json
  def create
    @tracking_list = current_tracking_list
    movie = Movie.find(params[:movie_id])
    @tracking_item = @tracking_list.add_movie(movie.id)
    @tracking_list = current_tracking_list
    notice_msg = @tracking_item ? 
        "Tracking item was successfully created." : 'Already in the list.';
    
    respond_to do |format|
      # if already in the list or new item to add
      if @tracking_item == nil || @tracking_item.save
        format.html { redirect_to @tracking_list, notice: notice_msg }
        format.js   { @current_item = @tracking_item }
        format.json { render json: @tracking_item, status: :created, location: @tracking_item }
      else
        format.html { render action: "new" }
        format.json { render json: @tracking_item.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # PUT /tracking_items/1
  # PUT /tracking_items/1.json
  def update
    @tracking_item = TrackingItem.find(params[:id])

    respond_to do |format|
      if @tracking_item.update_attributes(params[:tracking_item])
        format.html { redirect_to @tracking_item, notice: 'Tracking item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tracking_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracking_items/1
  # DELETE /tracking_items/1.json
  def destroy
    @tracking_item = TrackingItem.find(params[:id])
    @tracking_item.destroy

    respond_to do |format|
      format.html { redirect_to tracking_items_url }
      format.json { head :no_content }
    end
  end
end
