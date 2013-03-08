class DistrictsController < ApplicationController
  
  before_filter :get_district, :only => [:edit, :update, :destroy]
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
    respond_with(@district)
  end

  def edit
    @cantons = Canton.all
    @provinces = Province.all
  end

  def create
    @district = District.new(params[:district])

    respond_to do |format|
      if @district.save
        format.html { redirect_to @district, notice: t('.activerecord.models.district').capitalize + t('.notice.successfully_created') }
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
        format.html { redirect_to @district, notice:  t('.activerecord.models.district').capitalize + t('.notice.successfully_updated') }
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
      format.html { redirect_to districts_url, notice: t('.activerecord.models.district').capitalize + t('.notice.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def get_district
     @district = District.find(params[:id])
  end


  def fetch
    respond_with @district = District.fetch
  end

  def clean_cache
    District.clean_cache
  end
end
