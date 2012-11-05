class ProductPricingsController < ApplicationController
  # GET /product_pricings
  # GET /product_pricings.json
  def index
    #@product_pricings = ProductPricing.all
    #@product_pricing = ProductPricing.new
    #@product_pricings = ProductPricing.where(:product_id => params[:id])
    @title = I18n.t('.activerecord.models.product').pluralize
    @product_pricing = ProductPricing.where(:product_id => params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_pricings }
    end
  end

  # GET /product_pricings/1
  # GET /product_pricings/1.json
  def show
    @product_pricing = ProductPricing.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_pricing }
    end
  end

  # GET /product_pricings/new
  # GET /product_pricings/new.json
  def new
    @product_pricing = ProductPricing.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_pricing }
    end
  end

  # GET /product_pricings/1/edit
  def edit

    #@product_pricing = ProductPricing.find(params[:product_id])
    @product_pricing = ProductPricing.where(:product_id => params[:id])
  end

  # POST /product_pricings
  # POST /product_pricings.json
  def create
    @product_pricing = ProductPricing.new(params[:product_pricing])

    respond_to do |format|
      if @product_pricing.save
        flash[:notice] = t('.activerecord.models.product_pricing').capitalize + t('.notice.successfully_created')
        #format.html { redirect_to @product_pricing, notice: 'Product pricing was successfully created.' }
        format.html { redirect_to products_url, notice: t('.activerecord.models.product_pricing').capitalize + t('.notice.successfully_created') }
        format.json { render json: @product_pricing, status: :created, location: @product_pricing }
        format.js   
      else
        format.html { render action: "new" }
        format.json { render json: @product_pricing.errors, status: :unprocessable_entity }
        format.js 
      end
    end
  end

  # PUT /product_pricings/1
  # PUT /product_pricings/1.json
  def update
    @product_pricing = ProductPricing.find(params[:id])
    #@product_pricing = ProductPricing.where(:product_id => params[:id])

    respond_to do |format|
      if @product_pricing.update_attributes(params[:product_pricing])
        format.html { redirect_to products_path, notice: t('.activerecord.models.product_pricing').capitalize + t('.notice.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_pricing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_pricings/1
  # DELETE /product_pricings/1.json
  def destroy
    @product_pricing = ProductPricing.find(params[:id])
    @product_pricing.destroy

    respond_to do |format|
      #format.html { redirect_to product_pricings_url }
      format.html { redirect_to products_url, notice: t('.activerecord.models.product_pricing').capitalize + t('.notice.successfully_deleted') }
      format.json { head :no_content }
    end
  end
end
