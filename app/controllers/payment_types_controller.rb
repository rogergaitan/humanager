class PaymentTypesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_payment_type, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :js

  def index
    @payment_types = PaymentType.all
    respond_with(@payment_types)
  end

  def new
    @payment_type = PaymentType.new
    respond_with(@payment_type)
  end

  def edit
  end

  def create
    @payment_type = PaymentType.new(params[:payment_type])
    @payment_type.save

    respond_to do |format|
      format.html { redirect_to payment_types_url }
      format.json { head :no_content }
    end
  end

  def update
    @payment_type.update_attributes(params[:payment_type])
    respond_to do |format|
      format.html { redirect_to payment_types_url }
      format.json { head :no_content }
    end
  end

  def destroy
    @payment_type.destroy
    respond_with(@payment_type)
  end

  private
    def set_payment_type
      @payment_type = PaymentType.find(params[:id])
    end
end
