require 'will_paginate/array'

class ProductsController < ApplicationController
  respond_to :json, :html, :js, :pdf

  def index
    @products = Product.paginate(:page => params[:page], :per_page => 15)
    respond_with @products
  end

  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.pdf do
        render :pdf => "file_name"
      end
      format.json { render json: @product.to_json, :callback => params[:callback] }
    end
  end

  def new
    respond_with @product = Product.new
  end

  def edit
    @product_pricing = ProductPricing.new
    @application = ProductApplication.new
    @product = Product.find(params[:id])
    @product_pricings = ProductPricing.where(:product_id => params[:id])
    @applications = ProductApplication.where(:product_id => params[:id])
  end

  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        if params['continue']
          format.html { redirect_to new_product_path, 
            notice: t('.activerecord.models.product').capitalize +
             t('.notice.successfully_created') }
          format.json { render json: @product, status: :created, location: @product }
        else
          format.html { redirect_to @product, 
            notice: t('.activerecord.models.product').capitalize +
             t('.notice.successfully_created') }
          format.json { render json: @product, status: :created, location: @product }
        end  
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @product = Product.find(params[:id])
    @product_pricing = ProductPricing.where(:product_id => params[:id])
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product,
          notice: t('.activerecord.models.product').capitalize +
           t('.notice.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    
    respond_to do |format|
      format.html { redirect_to products_url, 
        notice: t('.activerecord.models.product').capitalize +
         t('.notice.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def search
    if params[:applications] or params[:name] or params[:code] or params[:part_number]  
      @products = Product.advance_search(params[:applications], params[:code], params[:name], params[:part_number]).to_a.paginate(:per_page => params[:per_page], :page => params[:page])
      #Rails.logger.debug @products
    else
      @products = Product.search(params[:search]).to_a.paginate(:per_page => params[:per_page], :page => params[:page])
    end
    respond_with @products
  end

  def set_cart
    Product.set_cart(params[:cart_products])
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def get_cart
    @products = Product.get_cart
    
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @products }
      format.pdf do
        pdf = ProductsPDF.new(@products)
        send_data pdf.render, filename: "products.pdf", type: "application/pdf", disposition: "inline"
        #clean_cache
      end
    end
  end

  def clean_cache
    Product.clean_cache
  end

  def quantity_available
    @quantity = Product.quantity_available(params[:id]) unless params[:id].nil?
    respond_with @quantity
  end
end
