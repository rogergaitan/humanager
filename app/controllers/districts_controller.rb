class DistrictsController < ApplicationController

  after_filter :clean_cache, :only => [:new, :edit, :destroy]
  respond_to :json, :html
  
  def index
    respond_with @districts = District.all
  end

  def show
    respond_with @district = District.find(params[:id])
  end

  def new
    @district = District.new
    @cantons = Canton.all
    @provinces = Province.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @district }
    end
  end

  def edit
    @district = District.find(params[:id])
    @cantons = Canton.all
    @provinces = Province.all
  end

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
    @district = District.find(params[:id])

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
    @district = District.find(params[:id])
    @district.destroy

    respond_to do |format|
      format.html { redirect_to districts_url }
      format.json { head :no_content }
    end
  end

  def fetch
    respond_with @district = District.fetch
  end

  def clean_cache
    District.clean_cache
  end
end
