class ProductApplicationsController < ApplicationController
  # GET /product_applications
  # GET /product_applications.json
  def index
    @product_applications = ProductApplication.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_applications }
    end
  end

  # GET /product_applications/1
  # GET /product_applications/1.json
  def show
    @product_application = ProductApplication.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_application }
    end
  end

  # GET /product_applications/new
  # GET /product_applications/new.json
  def new
    @product_application = ProductApplication.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_application }
    end
  end

  # GET /product_applications/1/edit
  def edit
    @product_application = ProductApplication.find(params[:id])
  end

  # POST /product_applications
  # POST /product_applications.json
  def create
    @product_application = ProductApplication.new()
    @product_application.name = params[:name]
    @product_application.product_id = params[:product_id]
    respond_to do |format|
      if @product_application.save
        flash[:notice] = @product_application.name  + t('.notice.successfully_created')
        format.html { redirect_to @product_application, notice: 'Product application was successfully created.' }
        format.json { render json: @product_application, status: :created, location: @product_application }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @product_application.errors, status: :unprocessable_entity }
        format.js
      end
#    respond_to do |format|
#      if @product_application.save
#        format.html { redirect_to @product_application, notice: t('.activerecord.models.product_application').capitalize + t('.notice.successfully_created') }
#        format.json { render json: @product_application, status: :created, location: @product_application }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @product_application.errors, status: :unprocessable_entity }
#      end
    end
  end

  # PUT /product_applications/1
  # PUT /product_applications/1.json
  def update
    @product_application = ProductApplication.find(params[:id])

    respond_to do |format|
      if @product_application.update_attributes(params[:product_application])
        format.html { redirect_to @product_application, notice: 'Product application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_applications/1
  # DELETE /product_applications/1.json
  def destroy
    @product_application = ProductApplication.find(params[:id])
    @product_application.destroy
    flash[:notice] = @product_application.name  + t('.notice.a_successfully_deleted')

    respond_to do |format|
      format.html { redirect_to product_applications_url, notice: 'Product application was successfully updated.' }
      format.json { head :no_content }
      format.js
    end
  end
end
