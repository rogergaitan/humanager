class CantonsController < ApplicationController
  # GET /cantons
  # GET /cantons.json
  def index
    @title = t('.activerecord.models.canton').capitalize.pluralize
    @cantons = Canton.joins(:province)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cantons }
    end
  end

  # GET /cantons/1
  # GET /cantons/1.json
  def show
    @title = t('.activerecord.models.canton').capitalize
    @canton = Canton.find(params[:id])
    @cantons = Canton.joins(:province)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @canton }
    end
  end

  # GET /cantons/new
  # GET /cantons/new.json
  def new
    @title = t('.activerecord.models.canton').capitalize
    @canton = Canton.new
    @provinces = Province.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @canton }
    end
  end

  # GET /cantons/1/edit
  def edit
    @title = t('.activerecord.models.canton').capitalize
    @canton = Canton.find(params[:id])
    @provinces = Province.all
  end

  # POST /cantons
  # POST /cantons.json
  def create
    @title = t('.activerecord.models.canton').capitalize
    @canton = Canton.new(params[:canton])

    respond_to do |format|
      if @canton.save
        format.html { redirect_to @canton, notice: t('.activerecord.models.canton').capitalize + t('.notice.a_successfully_created') }
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
    @canton = Canton.find(params[:id])

    respond_to do |format|
      if @canton.update_attributes(params[:canton])
        format.html { redirect_to @canton, notice: t('.activerecord.models.canton').capitalize + t('.notice.a_successfully_updated') }
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
    @canton.destroy

    respond_to do |format|
      format.html { redirect_to cantons_url, notice:  t('.activerecord.models.canton').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end
end
