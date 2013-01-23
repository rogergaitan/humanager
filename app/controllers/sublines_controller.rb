class SublinesController < ApplicationController

  after_filter :clean_cache, :only => [:new, :edit, :destroy]
  respond_to :json, :html


  # GET /sublines
  # GET /sublines.json
  def index
    @sublines = Subline.paginate(:page => params[:page], :per_page => 10)
    respond_with @sublines
  end

  # GET /sublines/1
  # GET /sublines/1.json
  def show
    @subline = Subline.find(params[:id])
    respond_with @subline
  end

  # GET /sublines/new
  # GET /sublines/new.json
  def new
    @subline = Subline.new
    respond_with @subline
  end

  # GET /sublines/1/edit
  def edit
    @subline = Subline.find(params[:id])
    #
  end

  # POST /sublines
  # POST /sublines.json
  # POST _create_and_show_or_create_and_continue_
  def create
    @subline = Subline.new(params[:subline])

    respond_to do |format|
      if @subline.save
        if params['continue']
          format.html { redirect_to new_subline_path, notice: t('.activerecord.models.subline').capitalize + t('.notice.a_successfully_created') }
          format.json { render json: @subline, status: :created, location: @subline }
        else
          format.html { redirect_to @subline, notice: t('.activerecord.models.subline').capitalize + t('.notice.a_successfully_created') }
          format.json { render json: @subline, status: :created, location: @subline }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @subline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sublines/1
  # PUT /sublines/1.json
  def update
    @subline = Subline.find(params[:id])

    respond_to do |format|
      if @subline.update_attributes(params[:subline])
        format.html { redirect_to @subline, notice: t('.activerecord.models.subline').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sublines/1
  # DELETE /sublines/1.json
  def destroy
    @subline = Subline.find(params[:id])
    @subline.destroy

    respond_to do |format|
      format.html { redirect_to sublines_url, notice: t('.activerecord.models.subline').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def search
      if params[:name]
        @sublines = Subline.search(params[:name])
      end  
    
    #Rails.logger.debug @subline
    respond_with @sublines
  end

  # SHORT /subline/short
  # Get All sublines including just the id and the name. 
  # We use this method on: *create* or *edit* products(dropdowns)
  def fetch
    respond_with Subline.fetch
  end

  def clean_cache
    Subline.clean_cache
  end

end
