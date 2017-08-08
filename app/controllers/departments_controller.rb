class DepartmentsController < ApplicationController
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:search]
  before_filter :resources, :only => [:new, :edit, :create, :update]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Department, params[:id])
  end

  respond_to :html, :json
  # GET /departments
  # GET /departments.json
  def index
    @departments = Department.paginate(:page => params[:page], :per_page => 15)
    respond_with(@departments)
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])
    respond_with(@department)
  end

  # GET /departments/new
  # GET /departments/new.json
  def new
    @department = Department.new
    respond_with(@department)
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(params[:department])

    respond_to do |format|
      if @department.save
        format.html { redirect_to departments_url, notice: 'Departamento creado exitosamente.' }
        format.json { render json: @department, status: :created, location: @department }
      else
        format.html { render action: "new" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /departments/1
  # PUT /departments/1.json
  def update
    @department = Department.find(params[:id])

    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html { redirect_to @department, notice: 'Departamento actualizado exitosamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department = Department.find(params[:id])
    @total = Employee.check_if_exist_records(params[:id], 'department')

    if @total > 0
      message = t('.notice.can_be_deleted')
    else
      @department.destroy
      message = t('.notice.successfully_deleted')
    end

    respond_to do |format|
      format.html { redirect_to departments_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  def resources
    @costs_centers = CostsCenter.where(company_id: current_user.company_id)
  end
  
  def search
    @departments = Department.search params[:name]
    respond_to do |format|
      format.json { render json: @departments }
    end
  end
end
