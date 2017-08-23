class CreditorsController < ApplicationController
  def index
    @creditors = Creditor.all
    respond_to  do |format|
      format.json {render json: @creditors}
    end
  end
  
end
