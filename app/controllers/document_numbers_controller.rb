class DocumentNumbersController < ApplicationController
  respond_to :json, :html
  before_filter :title

  def index
    respond_with @document_numbers = DocumentNumber.all
  end

  def show
    respond_with @document_number = DocumentNumber.find(params[:id])
  end

  def new
    respond_with @document_number = DocumentNumber.new
  end

  def edit
    @document_number = DocumentNumber.find(params[:id])
  end

  def create
    @document_number = DocumentNumber.new(params[:document_number])

    respond_to do |format|
      if @document_number.save
        format.html { redirect_to document_numbers_url, notice: t('.activerecord.models.document_number').capitalize + t('.notice.successfully_created') }
        format.json { render json: @document_number, status: :created, location: @document_number }
      else
        format.html { render action: "new" }
        format.json { render json: @document_number.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @document_number = DocumentNumber.find(params[:id])

    respond_to do |format|
      if @document_number.update_attributes(params[:document_number])
        format.html { redirect_to document_numbers_url, notice: t('.activerecord.models.document_number').capitalize + t('.notice.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document_number.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document_number = DocumentNumber.find(params[:id])
    @document_number.destroy

    respond_to do |format|
      format.html { redirect_to document_numbers_url, notice: t('.activerecord.models.document_number').capitalize + t('.notice.successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def title
    @title = t('.activerecord.models.document_number').capitalize + " - " + t(".helpers.links.#{action_name}" )
  end
end
