class QuotationItemsController < ApplicationController
  # GET /quotation_items
  # GET /quotation_items.json
  def index
    @quotation_items = QuotationItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @quotation_items }
    end
  end

  # GET /quotation_items/1
  # GET /quotation_items/1.json
  def show
    @quotation_item = QuotationItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quotation_item }
    end
  end

  # GET /quotation_items/new
  # GET /quotation_items/new.json
  def new
    @quotation_item = QuotationItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quotation_item }
    end
  end

  # GET /quotation_items/1/edit
  def edit
    @quotation_item = QuotationItem.find(params[:id])
  end

  # POST /quotation_items
  # POST /quotation_items.json
  def create
    @quotation_item = QuotationItem.new(params[:quotation_item])

    respond_to do |format|
      if @quotation_item.save
        format.html { redirect_to @quotation_item, notice: 'Quotation item was successfully created.' }
        format.json { render json: @quotation_item, status: :created, location: @quotation_item }
      else
        format.html { render action: "new" }
        format.json { render json: @quotation_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /quotation_items/1
  # PUT /quotation_items/1.json
  def update
    @quotation_item = QuotationItem.find(params[:id])

    respond_to do |format|
      if @quotation_item.update_attributes(params[:quotation_item])
        format.html { redirect_to @quotation_item, notice: 'Quotation item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quotation_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotation_items/1
  # DELETE /quotation_items/1.json
  def destroy
    @quotation_item = QuotationItem.find(params[:id])
    @quotation_item.destroy

    respond_to do |format|
      format.html { redirect_to quotation_items_url }
      format.json { head :no_content }
    end
  end
end
