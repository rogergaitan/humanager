class ShippingMethodsController < ApplicationController
  
  respond_to :json, :html
  after_filter :clean_cache, :only => [:new, :edit, :destroy]

  def index
    respond_with @shipping_methods = ShippingMethod.fetch_all
  end

  def show
    respond_with @shipping_method = ShippingMethod.find(params[:id])
  end

  def new
    respond_with @shipping_method = ShippingMethod.new
  end

  def edit
    @shipping_method = ShippingMethod.find(params[:id])
  end

  def create
    @shipping_method = ShippingMethod.new(params[:shipping_method])

    respond_to do |format|
      if @shipping_method.save
        format.html { redirect_to @shipping_method, notice: t('activerecord.models.shipping_method').capitalize + t('.notice.successfully_created') }
        format.json { render json: @shipping_method, status: :created, location: @shipping_method }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping_method.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @shipping_method = ShippingMethod.find(params[:id])

    respond_to do |format|
      if @shipping_method.update_attributes(params[:shipping_method])
        format.html { redirect_to @shipping_method, notice: t('activerecord.models.shipping_method').capitalize + t('.notice.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping_method.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @shipping_method = ShippingMethod.find(params[:id])
    @shipping_method.destroy

    respond_to do |format|
      format.html { redirect_to shipping_methods_url, notice: t('activerecord.models.shipping_method').capitalize + t('.notice.successfully_deleted')}
      format.json { head :no_content }
    end
  end



  def clean_cache
    ShippingMethod.clean_cache
  end
end
