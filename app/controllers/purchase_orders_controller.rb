class PurchaseOrdersController < ApplicationController
  
  respond_to :json
  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    @purchase_orders = PurchaseOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchase_orders }
    end
  end

  # GET /purchase_orders/1
  # GET /purchase_orders/1.json
  def show
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase_order }
    end
  end

  # GET /purchase_orders/new
  # GET /purchase_orders/new.json
  def new
    
    if params[:search] 
      @search = []
      @cart = Product.get_cart
        if @cart
          @cart.each do |key, value|
            @search.push(OpenStruct.new(value))
          end
        end
    end
    @purchase_order = PurchaseOrder.new
    @vendor = PurchaseOrder.get_vendor
    @new_vendor = Vendor.new
    @new_vendor.build_entity
  end

  # GET /purchase_orders/1/edit
  def edit
    @purchase_order = PurchaseOrder.find(params[:id])
    @vendor = PurchaseOrder.get_vendor(@purchase_order.vendor_id)
    @new_vendor = Vendor.new
    @new_vendor.build_entity
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(params[:purchase_order])

    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully created.' }
        format.json { render json: @purchase_order, status: :created, location: @purchase_order }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_orders/1
  # PUT /purchase_orders/1.json
  def update
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      if @purchase_order.update_attributes(params[:purchase_order])
        format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_orders/1
  # DELETE /purchase_orders/1.json
  def destroy
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.destroy

    respond_to do |format|
      format.html { redirect_to purchase_orders_url }
      format.json { head :no_content }
    end
  end


  def searchProduct
    @products = Product.search(params[:search])
    respond_with @products
  end

  def searchVendor
    @Vendor = Vendor.search(params[:search])
    respond_with @Vendor
  end

  def createvendor
    @new_vendor = Vendor.new(params[:vendor])
    @new_vendor.save
  end
  
  def tovendor
    @entity = Entity.find_by_entityid(params[:entityid])
    respond_to do |format|
      if @entity.create_vendor
        @vendor = @entity.vendor
        format.json { render json: @vendor, :include => :entity }
      else
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end
end
