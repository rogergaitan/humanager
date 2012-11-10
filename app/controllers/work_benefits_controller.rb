class WorkBenefitsController < ApplicationController
  # GET /work_benefits
  # GET /work_benefits.json
  def index
    @work_benefits = WorkBenefit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @work_benefits }
    end
  end

  # GET /work_benefits/1
  # GET /work_benefits/1.json
  def show
    @work_benefit = WorkBenefit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @work_benefit }
    end
  end

  # GET /work_benefits/new
  # GET /work_benefits/new.json
  def new
    @work_benefit = WorkBenefit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @work_benefit }
    end
  end

  # GET /work_benefits/1/edit
  def edit
    @work_benefit = WorkBenefit.find(params[:id])
  end

  # POST /work_benefits
  # POST /work_benefits.json
  def create
    @work_benefit = WorkBenefit.new(params[:work_benefit])

    respond_to do |format|
      if @work_benefit.save
        format.html { redirect_to @work_benefit, notice: 'Work benefit was successfully created.' }
        format.json { render json: @work_benefit, status: :created, location: @work_benefit }
      else
        format.html { render action: "new" }
        format.json { render json: @work_benefit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_benefits/1
  # PUT /work_benefits/1.json
  def update
    @work_benefit = WorkBenefit.find(params[:id])

    respond_to do |format|
      if @work_benefit.update_attributes(params[:work_benefit])
        format.html { redirect_to @work_benefit, notice: 'Work benefit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_benefit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_benefits/1
  # DELETE /work_benefits/1.json
  def destroy
    @work_benefit = WorkBenefit.find(params[:id])
    @work_benefit.destroy

    respond_to do |format|
      format.html { redirect_to work_benefits_url }
      format.json { head :no_content }
    end
  end
end
