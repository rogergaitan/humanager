require 'will_paginate/array'
class QuotationsController < ApplicationController
  
  respond_to :json, :html, :js
  before_filter :title
  before_filter :fetch, :only => [:new, :edit]
  before_filter :check_number, :only => [:new]

  def index
    respond_with @quotations = Quotation.includes(:customer => :entity)
      .paginate(page: params[:page], per_page: params[:per_page])
  end

  def show
    respond_with @quotation = Quotation.find(params[:id])
  end

  def new
    @quotation = Quotation.new
    @quotation.quotation_items.build
    respond_with @quotation
  end

  def edit
    @quotation = Quotation.includes(:quotation_items).find(params[:id])
    @customer = Quotation.customer_name(@quotation) if @quotation
  end

  def create
    @quotation = Quotation.new(params[:quotation])

    respond_to do |format|
      if @quotation.save
        format.html { redirect_to root_path, 
          notice: t('.activerecord.models.quotation.one').capitalize + 
            " #{@quotation.document_number} "+ 
            t('.notice.a_successfully_created') }
        format.json { render json: @quotation, status: :created, location: @quotation }
      else
        fetch
        format.html { render action: "new" }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @quotation = Quotation.find(params[:id])
    respond_to do |format|
      if @quotation.update_attributes(params[:quotation])
        format.html { redirect_to root_path, 
          notice: t('.activerecord.models.quotation.one').capitalize + 
            " #{@quotation.document_number} " +
            t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @quotation = Quotation.find(params[:id])
    @quotation.destroy

    respond_to do |format|
      format.html { redirect_to quotations_url, 
        notice: t('.activerecord.models.quotation.one').capitalize + 
          t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def title
    @title = t('.activerecord.models.quotation.one').capitalize + " - " + 
      t(".helpers.links.#{action_name}" )
  end

  def fetch
    @warehouses =  Warehouse.fetch
  end

  def search_customer
    respond_with Customer.search(params[:search]) if params[:search]
  end

  def check_number
    @document_number = DocumentNumber.check_number(:quotation)
  end

  def search
    # @quotations = nil
    # if params[:customer] and params[:customer].length >= 3
    #   @quotations = Quotation.search(nil, params[:customer])
    #     .to_a.paginate(:page => params[:page], :per_page => params[:per_page]) 
    # else 
    #   if params[:number]
    #     @quotations = Quotation.search(params[:number], nil)
    #     .to_a.paginate(:page => params[:page], :per_page => params[:per_page]) 
    #   end
    # end
    @quotations = Quotation.search(params[:search])
      .to_a.paginate(:page => params[:page], :per_page => params[:per_page]) unless params[:search].empty?
    respond_with @quotations 
  end
end
