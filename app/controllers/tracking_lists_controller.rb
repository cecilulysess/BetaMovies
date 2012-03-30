class TrackingListsController < ApplicationController
  # GET /tracking_lists
  # GET /tracking_lists.json
  def index
    @tracking_lists = TrackingList.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracking_lists }
    end
  end

  # GET /tracking_lists/1
  # GET /tracking_lists/1.json
  def show
    begin
      @tracking_list = TrackingList.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "Attmpt to access invalid TrackingList #{params[:id]}"
      redirect_to watch_url, :notice => "Invalid Tracking List"
    else 
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @tracking_list }
      end
    end
  end

  # GET /tracking_lists/new
  # GET /tracking_lists/new.json
  def new
    @tracking_list = TrackingList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tracking_list }
    end
  end

  # GET /tracking_lists/1/edit
  def edit
    @tracking_list = TrackingList.find(params[:id])
  end

  # POST /tracking_lists
  # POST /tracking_lists.json
  def create
    @tracking_list = TrackingList.new(params[:tracking_list])

    respond_to do |format|
      if @tracking_list.save
        format.html { redirect_to @tracking_list, notice: 'Tracking list was successfully created.' }
        format.json { render json: @tracking_list, status: :created, location: @tracking_list }
      else
        format.html { render action: "new" }
        format.json { render json: @tracking_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracking_lists/1
  # PUT /tracking_lists/1.json
  def update
    @tracking_list = TrackingList.find(params[:id])

    respond_to do |format|
      if @tracking_list.update_attributes(params[:tracking_list])
        format.html { redirect_to @tracking_list, notice: 'Tracking list was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tracking_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracking_lists/1
  # DELETE /tracking_lists/1.json
  def destroy
    @tracking_list = TrackingList.find(params[:id])
    @tracking_list.destroy

    respond_to do |format|
      format.html { redirect_to tracking_lists_url }
      format.json { head :no_content }
    end
  end
end
