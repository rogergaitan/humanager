class CompaniesController < ApplicationController
  before_filter :title
  respond_to :json, :html

  def index
    respond_with @companies = Company.all
  end

  def show
    respond_with @company = Company.find(params[:id])
  end

  def new
    respond_with @company = Company.new
  end

  def edit
    @company = Company.find(params[:id])
  end

  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        format.html { redirect_to companies_url, notice: t('.activerecord.models.company').capitalize + t('.notice.a_successfully_created') }
        format.json { render json: @company, status: :created, location: @company }
      else
        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to companies_url, notice: t('.activerecord.models.company').capitalize + t('.notice.a_successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url, notice: t('.activerecord.models.company').capitalize + t('.notice.a_successfully_deleted') }
      format.json { head :no_content }
    end
  end

  def title
    @title = t('.activerecord.models.company').capitalize + " - " + t(".helpers.links.#{action_name}" ) 
  end
end
