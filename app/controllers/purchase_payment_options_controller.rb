class PurchasePaymentOptionsController < ApplicationController
  # GET /purchase_payment_options
  # GET /purchase_payment_options.json
  def index
    @purchase_payment_options = PurchasePaymentOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchase_payment_options }
    end
  end

  # GET /purchase_payment_options/1
  # GET /purchase_payment_options/1.json
  def show
    @purchase_payment_option = PurchasePaymentOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase_payment_option }
    end
  end

  # GET /purchase_payment_options/new
  # GET /purchase_payment_options/new.json
  def new
    @purchase_payment_option = PurchasePaymentOption.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase_payment_option }
    end
  end

  # GET /purchase_payment_options/1/edit
  def edit
    @purchase_payment_option = PurchasePaymentOption.find(params[:id])
  end

  # POST /purchase_payment_options
  # POST /purchase_payment_options.json
  def create
    @purchase_payment_option = PurchasePaymentOption.new(params[:purchase_payment_option])

    respond_to do |format|
      if @purchase_payment_option.save
        format.html { redirect_to @purchase_payment_option, notice: 'Purchase payment option was successfully created.' }
        format.json { render json: @purchase_payment_option, status: :created, location: @purchase_payment_option }
      else
        format.html { render action: "new" }
        format.json { render json: @purchase_payment_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_payment_options/1
  # PUT /purchase_payment_options/1.json
  def update
    @purchase_payment_option = PurchasePaymentOption.find(params[:id])

    respond_to do |format|
      if @purchase_payment_option.update_attributes(params[:purchase_payment_option])
        format.html { redirect_to @purchase_payment_option, notice: 'Purchase payment option was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase_payment_option.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_payment_options/1
  # DELETE /purchase_payment_options/1.json
  def destroy
    @purchase_payment_option = PurchasePaymentOption.find(params[:id])
    @purchase_payment_option.destroy

    respond_to do |format|
      format.html { redirect_to purchase_payment_options_url }
      format.json { head :no_content }
    end
  end
end
