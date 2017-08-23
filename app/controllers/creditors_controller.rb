class CreditorsController < ApplicationController
  def index
    @creditors = Creditor.order :name
    respond_to  do |format|
      format.json {render json: @creditors}
    end
  end

end
