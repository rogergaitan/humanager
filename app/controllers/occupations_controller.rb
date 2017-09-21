# encoding: UTF-8

class OccupationsController < ApplicationController
  before_filter :set_occupation, :only => [:edit, :show, :update, :destroy]
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:search]
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
  end

  # POST /occupations
  # POST /occupations.json
  def create
    @occupation = Occupation.new(params[:occupation])

    respond_to do |format|
      if @occupation.save
        format.html { redirect_to @occupation, notice: 'Ocupación creada existosamente.' }
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
    respond_to do |format|
      if @occupation.update_attributes(params[:occupation])
        format.html { redirect_to @occupation, notice: 'Ocupación actualizada exitosamente.' }
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
    @total = Employee.check_if_exist_records(params[:id], 'occupation')

    if @total > 0
      message = t('.notice.can_be_deleted')
    else
      @occupation.destroy
      message = 'Ocupación eliminada existosamente.'
    end

    respond_to do |format|
      format.html { redirect_to occupations_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  def search
    @occupations = Occupation.search params[:name]
    respond_to do |format|
      format.json { render json: @occupations }
    end
  end
  
  private
  
    def set_occupation
      @occupation = Occupation.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to occupations_path, notice: "La ocupación que busca no existe."
    end
  
end
