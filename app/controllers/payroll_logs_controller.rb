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
        @payroll_log.payroll_total = @payroll_log.payroll_histories.sum(:total)
        @payroll_log.save

        if to_bool( params[:payroll_log]["continue_editing"] )
          format.html { redirect_to :action => "edit", :id => @payroll_log.id }
        end

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

  def resources
    company_id = PayrollLog.find(params[:id]).payroll.company_id
    @costs_centers = CostsCenter.where(" costs_centers.icompany = '#{company_id}' and costs_centers.icost_center != '' ")
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
    @tasks = Task.all
    @payment_types = PaymentType.where('state = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'])
  end

  def search_task
    @tasks = PayrollLog.search_task(params[:search_task_name], params[:page], params[:per_page])
    respond_with @tasks
  end

  def search_cost
    
    puts params[:company_id]

    @costs = PayrollLog.search_cost(params[:search_cost_name], params[:company_id], params[:page], params[:per_page])
    respond_with @costs
  end

  def search_employee
    @entities = PayrollLog.search_employee(params[:search_employee_name], params[:page], params[:per_page])
    respond_with @entities
  end

  def delete_employee_to_payment

    PayrollLog.delete_employee_to_payment(params[:employee_id], params[:payroll_history_id])

    if PayrollEmployee.where("payroll_employees.employee_id = ? AND payroll_employees.payroll_history_id = ?", params[:employee_id], params[:payroll_history_id]).exists?
      render :json => {:data => 'true'}
    else 
      render :json => {:data => 'false', :status => :unprocessable_entity}
    end
  end

end