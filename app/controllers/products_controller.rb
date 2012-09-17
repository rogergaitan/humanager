# Products Controller.
# Belongs to Line, Subline, Category
class ProductsController < ApplicationController
  
  # GET /products
  # GET /products.json
  def index
    #@products = Product.all

    @products = Product.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    # GET /products/1/edit
    @product_pricing = ProductPricing.new
    @product = Product.find(params[:id])
    #@product_pricing = ProductPricing.where(:product_id => params[:id])
    @product_pricings = ProductPricing.where(:product_id => params[:id])

  end

  # POST /products
  # POST /products.json
  # POST _create and show or create and continue_
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        if params['continue']
          format.html { redirect_to new_product_path, notice: 'Product was successfully created.' }
          format.json { render json: @product, status: :created, location: @product }
        else
          format.html { redirect_to @product, notice: 'Product was successfully created.' }
          format.json { render json: @product, status: :created, location: @product }
        end  
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    @product_pricing = ProductPricing.where(:product_id => params[:id])
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
end
