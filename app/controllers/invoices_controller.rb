class InvoicesController < ApplicationController
  
  before_filter :title
  before_filter :fetch, :check_number, :only => [:new, :edit]
  respond_to :json, :html, :js
  
  def index
    respond_with @invoices = Invoice.invoices_all(params[:page], 3)
  end

  def show
    respond_with @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new
    @invoice.invoice_items.build
    respond_with @invoice
  end

  def edit
    @invoice = Invoice.includes(:invoice_items).find(params[:id])
    @customer = Invoice.customer_name(@invoice) if @invoice
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
    flash[:notice] =  t('.activerecord.models.invoice').capitalize + 
      " #{@invoice.document_number} " + t('.notice.a_successfully_created') 
    respond_with(@invoice, :location => root_path)  
    else
      flash[:error] = @invoice.errors[:invoice_items][0] unless @invoice.errors[:invoice_items].empty?
      check_number
      fetch
      respond_with @invoice  
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = t('.activerecord.models.invoice').capitalize + 
        " #{@invoice.document_number} " + t('.notice.a_successfully_updated')
      respond_with(@invoice, :location => invoices_url)
    else
      fetch
      respond_with @invoice  
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    flash[:notice] = t('.activerecord.models.invoice').capitalize + 
      " #{@invoice.document_number} " + t('.notice.a_successfully_deleted')
    respond_with(@invoice, :location => invoices_url)
  end

  def fetch
    @warehouses ||=  Warehouse.fetch
  end

  def title
    @title = t('.activerecord.models.invoice').capitalize + " - " +
      t(".helpers.links.#{action_name}" )
  end

  def check_number
    @document_number = DocumentNumber.check_number(:invoice)
    Rails.logger.debug "auto_increment => #{@document_number}"
  end
  
  def search
    @invoices = Invoice.search(params[:search], params[:page], params[:per_page]) unless params[:search].empty?
    respond_with @invoices 
  end
end
