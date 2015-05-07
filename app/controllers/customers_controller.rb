class CustomersController < ApplicationController
 
  #filters
  before_filter :get_address_info, :only => [:new, :edit]

  #Respond block
  respond_to :json, :html

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all
    @customers = Customer.paginate(:page => params[:page], :per_page => 10)
    respond_with @customers
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])
    respond_with @customer
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new
    @entity = @customer.build_entity
    @entity.addresses.build
    @entity.contacts.build
    @entity.telephones.build

    respond_with @customer
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render json: @customer, status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
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
