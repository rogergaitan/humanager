class PurchaseOrdersController < ApplicationController

  respond_to :json, :js, :html
  before_filter :title
  before_filter :fetch_payment_info, :only => [:new, :edit]
  before_filter :fetch_shipping_types, :only => [:new, :edit]
  before_filter :check_number, :only => [:new]
  
  def index
    respond_with @purchase_orders = PurchaseOrder.includes(:vendor).all
  end

  def show
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @purchase_order }
      format.pdf do
        ### lib/purchase_order.rb
        pdf = PurchaseOrderPDF.new(@purchase_order)
        send_data pdf.render, filename: "OC-#{@purchase_order.id}.pdf",
          type: "application/pdf", disposition: "inline"
      end
    end
  end

  def new
    cart_items
    @purchase_order = PurchaseOrder.new
    @purchase_order.items_purchase_order.build
    @purchase_order.purchase_order_payments.build
    @new_vendor = Vendor.new
    @new_vendor.build_entity
  end

  def edit
    @purchase_order = PurchaseOrder.includes(:items_purchase_order).find(params[:id])
    @vendor = PurchaseOrder.get_vendor(@purchase_order)
    @new_vendor = Vendor.new
    @new_vendor.build_entity
    @warehouses = fetch_warehouses
  end

  def create
    @purchase_order = PurchaseOrder.new(params[:purchase_order])

    respond_to do |format|
      if @purchase_order.save
        if params[:print_pdf]
          format.html { redirect_to :action => "show", :id => @purchase_order.id, :format => :pdf, notice: 'Purchase order was successfully created.' }
        else
          format.html { redirect_to purchase_orders_url, 
            notice: t('.activerecord.models.purchase_order').capitalize +
            " #{@purchase_order.document_number} " +
            t('.notice.a_successfully_created') }
          format.json { render json: @purchase_order, status: :created, location: @purchase_order }
        end
      else
        fetch_shipping_types
        fetch_warehouses
        fetch_payment_info
        @new_vendor = Vendor.new
        format.html { render action: "new" }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @purchase_order = PurchaseOrder.find(params[:id])

    respond_to do |format|
      if @purchase_order.update_attributes(params[:purchase_order])
        if params[:print_pdf]
          format.html { redirect_to :action => "show", :id => @purchase_order.id, :format => :pdf }
        else
          format.html { redirect_to purchase_orders_url, 
            notice: t('.activerecord.models.purchase_order').capitalize +
            " #{@purchase_order.document_number} " +
            t('.notice.a_successfully_updated') }
          format.json { head :no_content }
        end
      else
        fetch_shipping_types
        fetch_warehouses
        @new_vendor = Vendor.new
        format.html { render action: "edit" }
        format.json { render json: @purchase_order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @purchase_order = PurchaseOrder.find(params[:id])
    @purchase_order.destroy
    flash[:notice] = "Orden eliminada correctamente"
    respond_to do |format|
      format.html { redirect_to purchase_orders_url, notice: t('.activerecord.models.purchase_order').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
      format.js
    end
  end

  def title
    @title = t('.activerecord.models.purchase_order').capitalize + " - " +
     t(".helpers.links.#{action_name}" )
  end

  def search_product
    respond_with @products = Product.search(params[:search])
  end

  def search_vendor
    respond_with @vendor = Vendor.search(params[:search])
  end

  def create_vendor
    @new_vendor = Vendor.new(params[:vendor])
    @new_vendor.save
  end

  def to_vendor
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

  def fetch_warehouses
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
    @warehouses = fetch_warehouses
  end

  def fetch_shipping_types
    @shipping_types   =  ShippingMethod.fetch_all    
  end
  
  def fetch_payment_info
    @payment_options  =  PaymentOption.fetch
    @payment_types    =  PaymentType.all
  end

  def check_number
    @document_number = DocumentNumber.check_number(:purchase_order)
  end
end
