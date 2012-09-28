class MeansOfPaymentsController < ApplicationController
  # GET /means_of_payments
  # GET /means_of_payments.json
  def index
    @means_of_payments = MeansOfPayment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @means_of_payments }
    end
  end

  # GET /means_of_payments/1
  # GET /means_of_payments/1.json
  def show
    @means_of_payment = MeansOfPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @means_of_payment }
    end
  end

  # GET /means_of_payments/new
  # GET /means_of_payments/new.json
  def new
    @means_of_payment = MeansOfPayment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @means_of_payment }
    end
  end

  # GET /means_of_payments/1/edit
  def edit
    @means_of_payment = MeansOfPayment.find(params[:id])
  end

  # POST /means_of_payments
  # POST /means_of_payments.json
  def create
    @means_of_payment = MeansOfPayment.new(params[:means_of_payment])

    respond_to do |format|
      if @means_of_payment.save
        format.html { redirect_to @means_of_payment, notice: 'Means of payment was successfully created.' }
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
    @means_of_payment = MeansOfPayment.find(params[:id])

    respond_to do |format|
      if @means_of_payment.update_attributes(params[:means_of_payment])
        format.html { redirect_to @means_of_payment, notice: 'Means of payment was successfully updated.' }
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
    @means_of_payment = MeansOfPayment.find(params[:id])
    @means_of_payment.destroy

    respond_to do |format|
      format.html { redirect_to means_of_payments_url }
      format.json { head :no_content }
    end
  end
end
