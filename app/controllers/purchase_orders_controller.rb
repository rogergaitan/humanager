class PurchaseOrdersController < ApplicationController

  respond_to :json, :js
  # GET /purchase_orders
  # GET /purchase_orders.json
  def index
    @purchase_orders = PurchaseOrder.includes(:vendor).all

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
      format.pdf do
        ### lib/purchase_order.rb
        pdf = PurchaseOrderPDF.new(@purchase_order)
        send_data pdf.render, filename: "OC-#{@purchase_order.id}.pdf", type: "application/pdf", disposition: "inline"

      end
    end

  end

  # GET /purchase_orders/new
  # GET /purchase_orders/new.json
  def new
    cart_items
    @purchase_order = PurchaseOrder.new
    @vendor = PurchaseOrder.get_vendor
    @new_vendor = Vendor.new
    @new_vendor.build_entity
    @shipping_type = ShippingMethod.all
  end

  # GET /purchase_orders/1/edit
  def edit
    @purchase_order = PurchaseOrder.find(params[:id])
    @vendor = PurchaseOrder.get_vendor(@purchase_order.vendor_id)
    @new_vendor = Vendor.new
    @new_vendor.build_entity
    @warehouses = fetch
    @shipping_type = ShippingMethod.all
  end

  # POST /purchase_orders
  # POST /purchase_orders.json
  def create
    @purchase_order = PurchaseOrder.new(params[:purchase_order])

    respond_to do |format|
      if @purchase_order.save
        if params[:print_pdf]
          format.html { redirect_to :action => "show", :id => @purchase_order.id, :format => :pdf, notice: 'Purchase order was successfully created.' }
        else
          format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully created.' }
          format.json { render json: @purchase_order, status: :created, location: @purchase_order }
        end
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
        if params[:print_pdf]
          format.html { redirect_to :action => "show", :id => @purchase_order.id, :format => :pdf }
        else
          format.html { redirect_to @purchase_order, notice: 'Purchase order was successfully updated.' }
          format.json { head :no_content }
        end
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
    flash[:notice] = "Orden eliminada correctamente"
    respond_to do |format|
      format.html { redirect_to purchase_orders_url }
      format.json { head :no_content }
      format.js
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

  def fetch
    @warehouses =  Warehouse.fetch
  end

  def cart_items
    @cart_items = []
    if params[:search]

      @cart = Product.get_cart
      if @cart
        @cart.each do |key, value|
          @cart_items.push(OpenStruct.new(value))

        end
      end
    end
    @warehouses = fetch
  end

end
