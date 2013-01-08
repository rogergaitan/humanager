class PaymentTypesController < ApplicationController
  # GET /payment_types
  # GET /payment_types.json
  def index
    @payment_types = PaymentType.all
    @payment_type = PaymentType.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_types }
    end
  end

  # GET /payment_types/1
  # GET /payment_types/1.json
  def show
    @payment_type = PaymentType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_type }
    end
  end

  # GET /payment_types/new
  # GET /payment_types/new.json
  def new
    @payment_type = PaymentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_type }
    end
  end

  # GET /payment_types/1/edit
  def edit
    @payment_type = PaymentType.find(params[:id])
  end

  # POST /payment_types
  # POST /payment_types.json
  def create
    @payment_type = PaymentType.new(params[:payment_type])

    respond_to do |format|
      if @payment_type.save
        flash[:notice] = t('.activerecord.models.payment_type').capitalize + " #{@payment_type.name}"  + t('.notice.successfully_created')
        format.html { redirect_to @payment_type }
        format.json { render json: @payment_type, status: :created, location: @payment_type }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /payment_types/1
  # PUT /payment_types/1.json
  def update
    @payment_type = PaymentType.find(params[:id])

    respond_to do |format|
      if @payment_type.update_attributes(params[:payment_type])
        
        format.html { redirect_to @payment_type }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_types/1
  # DELETE /payment_types/1.json
  def destroy
    @payment_type = PaymentType.find(params[:id])
    @payment_type.destroy
    flash[:notice] = t('.activerecord.models.payment_type').capitalize + " #{@payment_type.name}"  + t('.notice.successfully_deleted') 
    respond_to do |format|
      format.html { redirect_to payment_types_url }
      format.json { head :no_content }
      format.js
    end
  end
end
