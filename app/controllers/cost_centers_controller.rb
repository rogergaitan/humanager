class CostCentersController < ApplicationController
  # GET /cost_centers
  # GET /cost_centers.json
  def index
    @cost_centers = CostCenter.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cost_centers }
    end
  end

  # GET /cost_centers/1
  # GET /cost_centers/1.json
  def show
    @cost_center = CostCenter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cost_center }
    end
  end

  # GET /cost_centers/new
  # GET /cost_centers/new.json
  def new
    @cost_center = CostCenter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cost_center }
    end
  end

  # GET /cost_centers/1/edit
  def edit
    @cost_center = CostCenter.find(params[:id])
  end

  # POST /cost_centers
  # POST /cost_centers.json
  def create
    @cost_center = CostCenter.new(params[:cost_center])

    respond_to do |format|
      if @cost_center.save
        format.html { redirect_to @cost_center, notice: 'Cost center was successfully created.' }
        format.json { render json: @cost_center, status: :created, location: @cost_center }
      else
        format.html { render action: "new" }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cost_centers/1
  # PUT /cost_centers/1.json
  def update
    @cost_center = CostCenter.find(params[:id])

    respond_to do |format|
      if @cost_center.update_attributes(params[:cost_center])
        format.html { redirect_to @cost_center, notice: 'Cost center was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_centers/1
  # DELETE /cost_centers/1.json
  def destroy
    @cost_center = CostCenter.find(params[:id])
    @cost_center.destroy

    respond_to do |format|
      format.html { redirect_to cost_centers_url }
      format.json { head :no_content }
    end
  end
end
