class PayrollLogsController < ApplicationController
  before_filter :resources, :only => [:new, :edit]
  respond_to :html, :json, :js
  # GET /payroll_logs
  # GET /payroll_logs.json
  def index
    @payroll_logs = PayrollLog.paginate(:page => params[:page], :per_page => 15)
    respond_with(@payroll_logs)
  end

  # GET /payroll_logs/1
  # GET /payroll_logs/1.json
  def show
    @payroll_log = PayrollLog.find(params[:id])
    respond_with(@payroll_log)
  end

  # GET /payroll_logs/new
  # GET /payroll_logs/new.json
  def new
    @payroll_log = PayrollLog.new
    respond_with(@payroll_log)
  end

  # GET /payroll_logs/1/edit
  def edit
    @payroll_log = PayrollLog.find(params[:id])
    respond_with @result = PayrollLog.history(@payroll_log.id)
  end

  # POST /payroll_logs
  # POST /payroll_logs.json
  def create
    @payroll_log = PayrollLog.new(params[:payroll_log])

    respond_to do |format|
      if @payroll_log.save
        format.html { redirect_to payrolls_path, notice: 'Payroll log was successfully created.' }
        format.json { render json: @payroll_log, status: :created, location: @payroll_log }
      else
        format.html { render action: "new" }
        format.json { render json: @payroll_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payroll_logs/1
  # PUT /payroll_logs/1.json
  def update
    @payroll_log = PayrollLog.find(params[:id])

    respond_to do |format|
      if @payroll_log.update_attributes(params[:payroll_log])
        format.html { redirect_to payrolls_path, notice: 'Payroll log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payroll_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_logs/1
  # DELETE /payroll_logs/1.json
  def destroy
    @payroll_log = PayrollLog.find(params[:id])
    @payroll_log.destroy

    respond_to do |format|
      format.html { redirect_to payroll_logs_url }
      format.json { head :no_content }
    end
  end
  
  def fetch_employees
    @employees = Employee.includes(:entity).order_employees
    respond_to do |format|
      format.json { render json: @employees, :only => [:id, :employee_id, :department_id], :include => {:entity => {:only => [:name, :surname]} } }
    end
  end

  def fetch_employees
    @employees = Employee.includes(:entity).order_employees
    respond_to do |format|
      format.json { render json: @employees, :only => [:id, :employee_id, :department_id], :include => {:entity => {:only => [:name, :surname]} } }
    end
  end

  def resources
    @centro_costos = CentroDeCosto.all
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
    @tasks = Task.all
  end

  def search_task
    @tasks = PayrollLog.search_task(params[:search_task_name], params[:page], params[:per_page])
    respond_with @tasks
  end

  def search_cost
    @costs = PayrollLog.search_cost(params[:search_cost_name], params[:page], params[:per_page])
    respond_with @costs
  end

end