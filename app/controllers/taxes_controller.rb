class TaxesController < ApplicationController
  # GET /taxes
  # GET /taxes.json
  def index
    @taxes = Taxis.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxes }
    end
  end

  # GET /taxes/1
  # GET /taxes/1.json
  def show
    @taxis = Taxis.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxis }
    end
  end

  # GET /taxes/new
  # GET /taxes/new.json
  def new
    @taxis = Taxis.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxis }
    end
  end

  # GET /taxes/1/edit
  def edit
    @taxis = Taxis.find(params[:id])
  end

  # POST /taxes
  # POST /taxes.json
  def create
    @taxis = Taxis.new(params[:taxis])

    respond_to do |format|
      if @taxis.save
        format.html { redirect_to @taxis, notice: t('.activerecord.models.taxis').capitalize + t('.notice.successfully_created') }
        format.json { render json: @taxis, status: :created, location: @taxis }
      else
        format.html { render action: "new" }
        format.json { render json: @taxis.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxes/1
  # PUT /taxes/1.json
  def update
    @taxis = Taxis.find(params[:id])

    respond_to do |format|
      if @taxis.update_attributes(params[:taxis])
        format.html { redirect_to @taxis, notice: t('.activerecord.models.taxis').capitalize + t('.notice.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxis.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxes/1
  # DELETE /taxes/1.json
  def destroy
    @taxis = Taxis.find(params[:id])
    @taxis.destroy

    respond_to do |format|
      format.html { redirect_to taxes_url, notice: t('.activerecord.models.taxis').capitalize + t('.notice.successfully_deleted') }
      format.json { head :no_content }
    end
  end
end
