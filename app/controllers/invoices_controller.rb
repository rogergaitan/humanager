class InvoicesController < ApplicationController
  
  before_filter :title
  before_filter :fetch, :check_number, :only => [:new, :edit]
  respond_to :json, :html, :js
  
  def index
    respond_with @invoices = Invoice.invoices_all(params[:page], params[:per_page])
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
    respond_with(@invoice, :location => invoices_url)  
    else
      flash[:error] = @invoice.errors[:invoice_items][0] unless @invoice.errors[:invoice_items].empty?
      # flash[:error] = @invoice.errors.invoice_items
      check_number
      fetch
      respond_with @invoice  
    end
  end

=begin
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoices_url, 
          notice: t('.activerecord.models.invoice').capitalize + 
            " #{@invoice.document_number} "+ 
            t('.notice.a_successfully_created') }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        fetch
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end
=end

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

=begin  
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to invoices_url, 
          notice: t('.activerecord.models.invoice').capitalize + 
            " #{@invoice.document_number} " +
            t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    flash[:notice] = t('.activerecord.models.invoice').capitalize + 
      " #{@invoice.document_number} " + t('.notice.a_successfully_deleted')
    respond_with(@invoice, :location => invoices_url)
  end

=begin
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url,
        notice: t('.activerecord.models.invoice').capitalize + 
          " #{@invoice.document_number} " +
          t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end
=end

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
      # .to_a.paginate(:page => params[:page], :per_page => 5) unless params[:search].empty?
    respond_with @invoices 
  end
end
