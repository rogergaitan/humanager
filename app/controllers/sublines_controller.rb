class SublinesController < ApplicationController
  respond_to :json, :html
  # GET /sublines
  # GET /sublines.json
  def index
    @sublines = Subline.all
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

  # SHORT /subline/short
  # Get All sublines including just the id and the name. 
  # We use this method on: *create* or *edit* products(dropdowns)
  def fetch
    @names_ids = Subline.find(:all, :select =>['id','name']).to_json
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @names_ids }
    end
  end
end
