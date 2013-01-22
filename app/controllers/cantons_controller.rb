class CantonsController < ApplicationController
  
  after_filter :clean_cache, :only => [:new, :edit, :destroy]
  respond_to :json, :html

  def index
    respond_with @cantons = Canton.all
  end

  def show
    respond_with @canton = Canton.find(params[:id])
  end

  def new
    @canton = Canton.new
    @province = Province.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @canton }
    end
  end

  # GET /cantons/1/edit
  def edit
    @canton = Canton.find(params[:id])
  end

  def create
    @canton = Canton.new(params[:canton])

    respond_to do |format|
      if @canton.save
        format.html { redirect_to @canton, notice: 'Canton was successfully created.' }
        format.json { render json: @canton, status: :created, location: @canton }
      else
        format.html { render action: "new" }
        format.json { render json: @canton.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @canton = Canton.find(params[:id])

    respond_to do |format|
      if @canton.update_attributes(params[:canton])
        format.html { redirect_to @canton, notice: 'Canton was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @canton.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @canton = Canton.find(params[:id])
    @canton.destroy

    respond_to do |format|
      format.html { redirect_to cantons_url }
      format.json { head :no_content }
    end
  end

  def fetch
    respond_with @canton = Canton.fetch
  end
  
  def clean_cache
    Canton.clean_cache
  end
end
