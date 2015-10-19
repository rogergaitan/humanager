class OccupationsController < ApplicationController
  load_and_authorize_resource

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Occupation, params[:id])
  end

  respond_to :html, :json
  # GET /occupations
  # GET /occupations.json
  def index
    @occupations = Occupation.paginate(:page => params[:page], :per_page => 15)
    respond_with(@occupations)
  end

  # GET /occupations/1
  # GET /occupations/1.json
  def show
    @occupation = Occupation.find(params[:id])
    respond_with(@occupation)
  end

  # GET /occupations/new
  # GET /occupations/new.json
  def new
    @occupation = Occupation.new
    respond_with(@occupation)
  end

  # GET /occupations/1/edit
  def edit
    @occupation = Occupation.find(params[:id])
  end

  # POST /occupations
  # POST /occupations.json
  def create
    @occupation = Occupation.new(params[:occupation])

    respond_to do |format|
      if @occupation.save
        format.html { redirect_to @occupation, notice: 'Occupation was successfully created.' }
        format.json { render json: @occupation, status: :created, location: @occupation }
      else
        format.html { render action: "new" }
        format.json { render json: @occupation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /occupations/1
  # PUT /occupations/1.json
  def update
    @occupation = Occupation.find(params[:id])

    respond_to do |format|
      if @occupation.update_attributes(params[:occupation])
        format.html { redirect_to @occupation, notice: 'Occupation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @occupation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occupations/1
  # DELETE /occupations/1.json
  def destroy
    @occupation = Occupation.find(params[:id])
    @total = Employee.check_if_exist_records(params[:id], 'occupation')

    if @total > 0
      message = t('.notice.can_be_deleted')
    else
      @occupation.destroy
      message = t('.notice.successfully_deleted')
    end

    respond_to do |format|
      format.html { redirect_to occupations_url, notice: message }
      format.json { head :no_content }
    end
  end
end
