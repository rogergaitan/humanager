class CantonsController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json
  before_filter :get_canton, :only => [:edit, :update, :destroy]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Canton, params[:id])
  end

  def get_canton
    @canton = Canton.find(params[:id])
  end

  # GET /cantons
  # GET /cantons.json
  def index
    @cantons = Canton.all
    respond_with(@cantons)
  end

  # GET /cantons/1
  # GET /cantons/1.json
  def show
    @canton = Canton.find(params[:id])
    respond_with(@canton)
  end

  # GET /cantons/new
  # GET /cantons/new.json
  def new
    @canton = Canton.new
    @province = Province.all
    respond_with(@canton)
  end

  # GET /cantons/1/edit
  def edit
    @province = Province.all
  end

  # POST /cantons
  # POST /cantons.json
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

  # PUT /cantons/1
  # PUT /cantons/1.json
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

  # DELETE /cantons/1
  # DELETE /cantons/1.json
  def destroy
    
    @canton = Canton.find(params[:id])
    @result = Entity.check_if_exist_addresses(params[:id], "canton")

    if @result > 0
      message = t('.notice.can_be_deleted')
    else
      @canton.destroy
      message = t('.notice.successfully_deleted')
    end

    respond_to do |format|
      format.html { redirect_to cantons_url, notice: message }
      format.json { head :no_content }
    end
  end

end
