require 'will_paginate/array'

class PurchasesController < ApplicationController

  before_filter :title
  before_filter :fetch_warehouses, :only => [:new, :edit]
  before_filter :fetch_payment_types, :only => [:new, :edit] 
  before_filter :fetch_payment_options, :only => [:new, :edit]
  respond_to :json, :js, :html

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.paginate(:page => params[:page], :per_page => 10)
    respond_with @purchases
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
      format.pdf do
        ### lib/purchase_pdf.rb
        pdf = PurchasePDF.new(@purchase)
        send_data pdf.render, filename: "C-#{@purchase.id}.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end

  # GET /purchases/new
  # GET /purchases/new.json
  def new
    @purchase = Purchase.new
    @purchase.purchase_items.build
    @purchase.purchase_payment_options.build 
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/1/edit
  def edit
    @purchase = Purchase.find(params[:id])
    @vendor = Purchase.get_vendor(@purchase.vendor_id)
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(params[:purchase])

    respond_to do |format|
      if @purchase.errors.empty? && @purchase.save
        format.html { redirect_to purchases_path, notice: t('.activerecord.models.purchase').capitalize + t('.notice.a_successfully_created') }
        format.json { render json: @purchase, status: :created, location: @purchase }
      else
        #flash[:alert] = @purchase.errors.full_messages.to_sentence
        #Rails.logger.debug @purchase.errors.full_messages.to_sentence
        #Rails.logger.debug flash[:notice]
        fetch_warehouses
        fetch_payment_options
        fetch_payment_types
        format.html { render action: "new" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
        
      end
    end
  end

  # PUT /purchases/1
  # PUT /purchases/1.json
  def update
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      if @purchase.update_attributes(params[:purchase])
        format.html { redirect_to purchases_path, notice: t('.activerecord.models.purchase').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase = Purchase.find(params[:id])
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url, notice: t('.activerecord.models.purchase').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def title
    @title = t('.activerecord.models.purchase').capitalize + " - " + t(".helpers.links.#{action_name}" ) 
  end

  def search_vendor
    @vendor = Vendor.search(params[:search])
    respond_with @vendor
  end

  def fetch_warehouses
    @warehouses =  Warehouse.fetch
  end

  def fetch_payment_options
    @payment_options =  PaymentOption.fetch
  end

  def fetch_payment_types
    @payment_types =  PaymentType.all
  end

  def search
    @purchases = Purchase.search(params[:search]).to_a.paginate(:page => params[:page], :per_page => 10) if params[:search] and params[:search].length >= 3
    respond_with @purchases
  end

end
