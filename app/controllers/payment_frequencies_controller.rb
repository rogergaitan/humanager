class PaymentFrequenciesController < ApplicationController
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
    @payment_frequency = PaymentFrequency.find(params[:id])
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
    @payment_frequency = PaymentFrequency.find(params[:id])
  end

  # POST /payment_frequencies
  # POST /payment_frequencies.json
  def create
    @payment_frequency = PaymentFrequency.new(params[:payment_frequency])

    respond_to do |format|
      if @payment_frequency.save
        format.html { redirect_to @payment_frequency, notice: 'Payment frequency was successfully created.' }
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
    @payment_frequency = PaymentFrequency.find(params[:id])

    respond_to do |format|
      if @payment_frequency.update_attributes(params[:payment_frequency])
        format.html { redirect_to @payment_frequency, notice: 'Payment frequency was successfully updated.' }
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
    @payment_frequency = PaymentFrequency.find(params[:id])
    @payment_frequency.destroy

    respond_to do |format|
      format.html { redirect_to payment_frequencies_url }
      format.json { head :no_content }
    end
  end
end
