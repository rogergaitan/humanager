class PositionsController < ApplicationController
  authorize_resource
  skip_load_and_authorize_resource :only => [:search]
  before_filter :set_position, only: [:show, :edit, :update, :destroy]
  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Position, params[:id])
  end
  
  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @position }
    end
  end

  # GET /positions/new
  # GET /positions/new.json
  def new
    @position = Position.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @position }
    end
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(params[:position])

    respond_to do |format|
      if @position.save
        format.html { redirect_to @position, notice: 'Puesto creado exitosamente.' }
        format.json { render json: @position, status: :created, location: @position }
      else
        format.html { render action: "new" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.json
  def update
    respond_to do |format|
      if @position.update_attributes(params[:position])
        format.html { redirect_to @position, notice: 'Puesto actualizado exitosamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    byebug
    @total = Employee.check_if_exist_records(params[:id], 'position')

    if @total > 0
      message = t('.notice.can_be_deleted')
    else
      @position.destroy
      message = t('.notice.successfully_deleted')
    end
    
    respond_to do |format|
      format.html { redirect_to positions_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  def search
    @positions = Position.search params[:name]
    respond_to do |format|
      format.json { render json: @positions }
    end
  end
  
  private
  
    def set_position
      @position = Position.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to positions_path, notice: "El puesto que busca no existe."
    end
  
end
