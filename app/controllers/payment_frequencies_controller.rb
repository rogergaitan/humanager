class PaymentFrequenciesController < ApplicationController
  authorize_resource

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(PaymentFrequency, params[:id])
  end
  
  before_filter :set_payment_frequency, :only => [:edit, :show, :update, :delete]

  respond_to :html, :json
  
  # GET /payment_frequencies
  # GET /payment_frequencies.json
  def index
    @payment_frequencies = PaymentFrequency.paginate(:page => params[:page], :per_page => 15)
    respond_with(@payment_frequencies)
  end

  # GET /payment_frequencies/1
  # GET /payment_frequencies/1.json
  def show
    respond_with(@payment_frequency)
  end

  # GET /payment_frequencies/new
  # GET /payment_frequencies/new.json
  def new
    @payment_frequency = PaymentFrequency.new
    respond_with(@payment_frequency)
  end

  # GET /payment_frequencies/1/edit
  def edit
  end

  # POST /payment_frequencies
  # POST /payment_frequencies.json
  def create
    @payment_frequency = PaymentFrequency.new(params[:payment_frequency])

    respond_to do |format|
      if @payment_frequency.save
        format.html { redirect_to @payment_frequency, notice: 'Frecuencia de pago creada correctamente.' }
        format.json { render json: @payment_frequency, status: :created, location: @payment_frequency }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_frequency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_frequencies/1
  # PUT /payment_frequencies/1.json
  def update
    respond_to do |format|
      if @payment_frequency.update_attributes(params[:payment_frequency])
        format.html { redirect_to @payment_frequency, notice: 'Frecuencia de pago actualizada correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_frequency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_frequencies/1
  # DELETE /payment_frequencies/1.json
  def destroy
    @total = Employee.check_if_exist_records(params[:id], 'payment_frequency')

    if @total > 0
      message = t('.notice.can_be_deleted')
    else
      @payment_frequency.destroy
      message = t('.notice.successfully_deleted')
    end

    respond_to do |format|
      format.html { redirect_to payment_frequencies_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  private
  
    def set_payment_frequency
      @payment_frequency = PaymentFrequency.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to payment_frequencies_path, notice: "La frecuencia de pago que busca no existe."
    end
  
end
