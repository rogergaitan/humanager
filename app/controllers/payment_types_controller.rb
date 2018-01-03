class PaymentTypesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_payment_type, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:change_status, :destroy]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(PaymentType, params[:id])
  end

  respond_to :html, :json, :js

  def index
    @payment_types = PaymentType.find_by_company_id(current_user.company_id)
                                      .paginate(:page => params[:page], :per_page => 15)
                                          
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
      format.html { redirect_to action: :index }
      format.json { head :no_content }
    end
  end

  def destroy
    if PayrollHistory.where(payment_type_id: params[:id]).count() > 0
      respond_to do |format|
        format.json { render json: { notice: t('.notice.can_be_deleted')+' '+t('.notice.change_status') }, status: :conflict }
      end
    else
      respond_to do |format|
        if @payment_type.destroy
          format.json { render json: { notice: t('.notice.successfully_deleted') }, status: :ok }
        else
          format.json { render json: { notice: @payment_type.errors }, status: :unprocessable_entity }
        end
      end
    end
  end

  def change_status

    payment_type = PaymentType.find(params[:id])

    if to_bool(params[:state])
      payment_type.state = PaymentType::STATE_ACTIVE
    else
      payment_type.state = PaymentType::STATE_COMPLETED
    end   

    respond_to do |format|
      if payment_type.save
        format.json { render json: { 'status' => true }, status: :created }
      else
        format.json { render json: { 'status' => false, 'errors' => payment_type.errors }, status: :unprocessable_entity }
      end
    end
  end

  private
  
  def set_payment_type
    @payment_type = PaymentType.find(params[:id])
  end

end
