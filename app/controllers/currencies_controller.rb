class CurrenciesController < ApplicationController
  before_filter :set_currency, only: [:edit, :update]
  load_and_authorize_resource
  
  def index
    @currencies = Currency.all
  end
    
  def edit
  end
  
  def update
    if @currency.update_attributes params[:currency]
      redirect_to currencies_path, notice: "Moneda actualizada correctamente."
    else
      render :edit
    end
  end
  
  private
  
    def set_currency
      @currency = Currency.find params[:id]    
    rescue ActiveRecord::RecordNotFound
      redirect_to currencies_path, notice: "El registro de moneda que busca no existe."
    end
  
end
