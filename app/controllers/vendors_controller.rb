class VendorsController < ApplicationController
  
  #filters
  before_filter :get_address_info, :only => [:new, :edit]

  #Respond block
  respond_to :json, :html
  
  # GET /vendors
  # GET /vendors.json
  def index
    @vendors = Vendor.all
    respond_with @vendors
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
    @vendor = Vendor.find(params[:id])
    respond_with @vendor
  end

  # GET /vendors/new
  # GET /vendors/new.json
  def new
    @vendor = Vendor.new
    @entity = @vendor.build_entity
    @entity.addresses.build
    @entity.contacts.build
    @entity.telephones.build
    @entity.bank_accounts.build 
  end

  # GET /vendors/1/edit
  def edit
    @vendor = Vendor.find(params[:id])
  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor = Vendor.new(params[:vendor])

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to @vendor, notice: t('.activerecord.models.vendor').capitalize + t('.notice.successfully_created') }
        format.json { render json: @vendor, status: :created, location: @vendor }
      else
        format.html { render action: "new" }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendors/1
  # PUT /vendors/1.json
  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
        format.html { redirect_to @vendor, notice: t('.activerecord.models.vendor').capitalize + t('.notice.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to vendors_url, notice: t('.activerecord.models.vendor').capitalize + t('.notice.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  # Before filter method to get provinces, cantons and districts
  def get_address_info
    @province ||= Province.find(:all, :select =>['id','name'])
    @canton ||= Canton.find(:all, :select =>['id','name', 'province_id'])
    @district ||= District.find(:all, :select =>['id','name', 'canton_id'])
  end

end
