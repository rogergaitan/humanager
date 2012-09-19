class DistrictsController < ApplicationController
  # GET /districts
  # GET /districts.json
  def index
    @title = t('.activerecord.models.district').pluralize
    @districts = District.joins(:canton)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @districts }
    end
  end

  # GET /districts/1
  # GET /districts/1.json
  def show
    @title = t('.activerecord.models.district')
    @district = District.find(params[:id])
    @districts = District.joins(:canton)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @district }
    end
  end

  # GET /districts/new
  # GET /districts/new.json
  def new
    @title = t('.activerecord.models.district').capitalize
    @district = District.new
    @cantons = Canton.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @district }
    end
  end

  # GET /districts/1/edit
  def edit
    @title = t('.activerecord.models.district').capitalize
    @district = District.find(params[:id])
     @cantons = Canton.all
  end

  # POST /districts
  # POST /districts.json
  def create
    @title = t('.activerecord.models.district').capitalize
    @district = District.new(params[:district])

    respond_to do |format|
      if @district.save
        format.html { redirect_to @district, notice: t('.activerecord.models.district').capitalize + t('.notice.a_successfully_created') }
        format.json { render json: @district, status: :created, location: @district }
      else
        format.html { render action: "new" }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /districts/1
  # PUT /districts/1.json
  def update
    @district = District.find(params[:id])

    respond_to do |format|
      if @district.update_attributes(params[:district])
        format.html { redirect_to @district, notice: t('.activerecord.models.district').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /districts/1
  # DELETE /districts/1.json
  def destroy
    @district = District.find(params[:id])
    @district.destroy

    respond_to do |format|
      format.html { redirect_to districts_url, notice: t('.activerecord.models.district').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end
end
