class MeansOfPaymentsController < ApplicationController
  authorize_resource

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(MeansOfPayment, params[:id])
  end

  before_filter :set_means_of_payment, :only => [:edit, :update, :delete, :show]
  
  respond_to :html, :json

  # GET /means_of_payments
  # GET /means_of_payments.json
  def index
    @means_of_payments = MeansOfPayment.paginate(:page => params[:page], :per_page => 15)
    respond_with(@means_of_payments)
  end

  # GET /means_of_payments/1
  # GET /means_of_payments/1.json
  def show
    @means_of_payment = MeansOfPayment.find(params[:id])
    respond_with(@means_of_payment)
  end

  # GET /means_of_payments/new
  # GET /means_of_payments/new.json
  def new
    @means_of_payment = MeansOfPayment.new
    respond_with(@means_of_payment)
  end

  # GET /means_of_payments/1/edit
  def edit
  end

  # POST /means_of_payments
  # POST /means_of_payments.json
  def create
    @means_of_payment = MeansOfPayment.new(params[:means_of_payment])

    respond_to do |format|
      if @means_of_payment.save
        format.html { redirect_to @means_of_payment, notice: 'Medio de pago creado correctamente.' }
        format.json { render json: @means_of_payment, status: :created, location: @means_of_payment }
      else
        format.html { render action: "new" }
        format.json { render json: @means_of_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /means_of_payments/1
  # PUT /means_of_payments/1.json
  def update
    respond_to do |format|
      if @means_of_payment.update_attributes(params[:means_of_payment])
        format.html { redirect_to @means_of_payment, notice: 'Medio de pago actualizado correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @means_of_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /means_of_payments/1
  # DELETE /means_of_payments/1.json
  def destroy
    @total = Employee.check_if_exist_records(params[:id], 'means_of_payment')

    if @total > 0
      message = t('.notice.can_be_deleted')
    else
      @means_of_payment.destroy
      message = t('.notice.successfully_deleted')
    end

    respond_to do |format|
      format.html { redirect_to means_of_payments_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  private
  
    def set_means_of_payment
      @means_of_payment = MeansOfPayment.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to means_of_payments_path, notice: "El medio de pago que busca no existe."
    end
  
end
