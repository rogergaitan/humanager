class DistrictsController < ApplicationController
  respond_to :html, :json
  before_filter :is_login, :only => [:index, :show, :new, :edit, :create, :update, :destroy]
  before_filter :get_district, :only => [:edit, :update, :destroy]

  def get_district
     @district = District.find(params[:id])
  end
  
  # GET /districts
  # GET /districts.json
  def index
    @districts = District.all
    respond_with(@districts)
  end

  # GET /districts/1
  # GET /districts/1.json
  def show
    @district = District.find(params[:id])
    respond_with(@district)
  end

  # GET /districts/new
  # GET /districts/new.json
  def new
    @district = District.new
    @cantons = Canton.all
    @provinces = Province.all
    respond_with(@district)
  end

  # GET /districts/1/edit
  def edit
    @cantons = Canton.all
    @provinces = Province.all
  end

  # POST /districts
  # POST /districts.json
  def create
    @district = District.new(params[:district])

    respond_to do |format|
      if @district.save
        format.html { redirect_to @district, notice: 'District was successfully created.' }
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
    respond_to do |format|
      if @district.update_attributes(params[:district])
        format.html { redirect_to @district, notice: 'District was successfully updated.' }
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
    @district.destroy

    respond_to do |format|
      format.html { redirect_to districts_url }
      format.json { head :no_content }
    end
  end
end
