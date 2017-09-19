class PaymentUnitsController < ApplicationController
  before_filter :set_payment_unit, only: [:edit, :update, :destroy]
  
  def index
    @payment_units = PaymentUnit.paginate page: params[:page], per_page: 15
  end
  
  def new
    @payment_unit = PaymentUnit.new
  end
  
  def edit
  end
  
  def create
    @payment_unit = PaymentUnit.new params[:payment_unit]
    if @payment_unit.save
      redirect_to payment_units_path, notice: "Unidad de pago creada correctamente."
    else
      render :new
    end
  end
  
  def update
    if @payment_unit.update_attributes params[:payment_unit]
      redirect_to payment_units_path, notice: "Unidad de pago actualizada correctamente."
    else
      render :edit
    end
  end
  
  def destroy
    @payment_unit.destroy
    redirect_to payment_units_path, notice: t('.notice.successfully_deleted')
  end
  
  private
  
    def set_payment_unit
      @payment_unit = PaymentUnit.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to payment_units_path, notice: "La unidad de pago que busca no existe."
    end
  
end
