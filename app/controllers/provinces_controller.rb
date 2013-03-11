class ProvincesController < ApplicationController
  
  after_filter :clean_cache, :only => [:new, :edit, :destroy]
  before_filter :get_province, :only => [:edit, :update, :destroy]
  
  respond_to :html, :json

  def get_province
    @province = Province.find(params[:id])
  end

  # GET /provinces
  # GET /provinces.json
  def index
    @provinces = Province.all
    respond_with(@provinces)
  end

  # GET /provinces/1
  # GET /provinces/1.json
  def show
    @province = Province.find(params[:id])
    respond_with(@province)
  end

  # GET /provinces/new
  # GET /provinces/new.json
  def new
    @province = Province.new
    respond_with(@province)
  end

  # GET /provinces/1/edit
  def edit
  end

  # POST /provinces
  # POST /provinces.json
  def create
    @province = Province.new(params[:province])

    respond_to do |format|
      if @province.save
        format.html { redirect_to @province, notice: t('.activerecord.models.province').capitalize + t('.notice.a_successfully_created') }
        format.json { render json: @province, status: :created, location: @province }
      else
        format.html { render action: "new" }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /provinces/1
  # PUT /provinces/1.json
  def update
    respond_to do |format|
      if @province.update_attributes(params[:province])
        format.html { redirect_to @province, notice: t('.activerecord.models.province').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provinces/1
  # DELETE /provinces/1.json
  def destroy
    @province.destroy

    respond_to do |format|
      format.html { redirect_to provinces_url, notice: t('.activerecord.models.province').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def fetch
    respond_with @province = Province.fetch
  end
  
  def clean_cache
    Province.clean_cache
  end
end
