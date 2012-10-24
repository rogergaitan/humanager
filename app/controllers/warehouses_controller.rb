# -*- encoding : utf-8 -*-
class WarehousesController < ApplicationController
  # GET /warehouses
  # GET /warehouses.json,
  # index paginated
  def index
    @title = t('.activerecord.models.warehouse').pluralize
    @warehouses = Warehouse.all
    @warehouses = Warehouse.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @warehouses }
    end
  end

  # GET /warehouses/1
  # GET /warehouses/1.json
  def show
    @title = t('.activerecord.models.warehouse')
    @warehouse = Warehouse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @warehouse }
    end
  end

  # GET /warehouses/new
  # GET /warehouses/new.json
  def new
    @title = 'Bodega'
    @warehouse = Warehouse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @warehouse }
    end
  end

  # GET /warehouses/1/edit
  def edit
    @title = t('.activerecord.models.warehouse')
    @warehouse = Warehouse.find(params[:id])
  end

  # POST /warehouses
  # POST /warehouses.json
  def create
    @warehouse = Warehouse.new(params[:warehouse])

    respond_to do |format|
      if @warehouse.save
        if params['continue']
          format.html { redirect_to new_warehouse_path, notice: t('.activerecord.models.warehouse').capitalize + t('.notice.a_successfully_created') }
          format.json { render json: @warehouse, status: :created, location: @warehouse }
        else
          format.html { redirect_to @warehouse, notice: t('.activerecord.models.warehouse').capitalize + t('.notice.a_successfully_created') }
          format.json { render json: @warehouse, status: :created, location: @warehouse }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /warehouses/1
  # PUT /warehouses/1.json
  def update
    @warehouse = Warehouse.find(params[:id])

    respond_to do |format|
      if @warehouse.update_attributes(params[:warehouse])
        format.html { redirect_to @warehouse, notice: t('.activerecord.models.warehouse').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /warehouses/1
  # DELETE /warehouses/1.json
  def destroy
    @warehouse = Warehouse.find(params[:id])
    @warehouse.destroy

    respond_to do |format|
      format.html { redirect_to warehouses_url, notice: t('.activerecord.models.warehouse').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end
end
