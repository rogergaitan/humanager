class CantonsController < ApplicationController

  after_filter :clean_cache, :only => [:new, :edit, :destroy]
  before_filter :get_canton, :only => [:edit, :update, :destroy]

  respond_to :json, :html

  def index
    respond_with @cantons = Canton.all
  end

  def get_canton
    @canton = Canton.find(params[:id])
  end

  def index
    respond_with @cantons = Canton.all
  end

  def show
    respond_with @canton = Canton.find(params[:id])
  end

  def new
    @canton = Canton.new
    @province = Province.all
    respond_with(@canton)
  end

  # GET /cantons/1/edit
  def edit
    @province = Province.all
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
