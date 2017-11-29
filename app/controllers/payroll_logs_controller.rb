class PayrollLogsController < ApplicationController
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit, :update]
  skip_before_filter :verify_authenticity_token, :only => [:set_custom_update]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(PayrollLog, params[:id])
  end

  respond_to :html, :json, :js

  # GET /payroll_logs and /payroll_logs.json
  def index
    # redirect to root path and sending any flash messages
    redirect_to root_path, flash: flash
  end

  # GET /payroll_logs/1 and /payroll_logs/1.json
  def show
    @payroll_log = PayrollLog.find(params[:id])
    respond_with(@payroll_log)
  end

  # GET /payroll_logs/new and /payroll_logs/new.json
  def new
    @payroll_log = PayrollLog.new
    respond_with(@payroll_log)
  end

  # GET /payroll_logs/1/edit
  def edit
    @payroll_log = PayrollLog.find(params[:id])
    respond_with @result = PayrollLog.history(@payroll_log.id)
  end

  # POST /payroll_logs and /payroll_logs.json
  def create
    @payroll_log = PayrollLog.new(params[:payroll_log])

    respond_to do |format|
      if @payroll_log.save
        format.html { redirect_to payrolls_path, notice: 'Planilla creada correctamente.' }
        format.json { render json: @payroll_log, status: :created, location: @payroll_log }
      else
        format.html { render action: "new" }
        format.json { render json: @payroll_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payroll_logs/1 and /payroll_logs/1.json
  def update
    @payroll_log = PayrollLog.find(params[:id])
    @result = PayrollLog.history(@payroll_log.id)

    respond_to do |format|
      if @payroll_log.update_attributes(params[:payroll_log])
        @payroll_log.payroll_total = @payroll_log.payroll_histories.sum(:total)
        @payroll_log.save

        if to_bool( params[:payroll_log]["continue_editing"] )
          format.html { redirect_to :action => "edit", :id => @payroll_log.id }
        end

        format.html { redirect_to payrolls_path, notice: 'Planilla actualizada correctamente.' }
        format.json { head :no_content }

      else
        format.html { render action: "edit" }
        format.json { render json: @payroll_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_logs/1 and /payroll_logs/1.json
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
    @payment_types = PaymentType.find_by_company_id current_user.company_id
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
  end

  def search_task
    tasks = PayrollLog.search_task(params[:task_name], params[:task_code], params[:task_iactivity], 
                                   params[:page], params[:per_page])
    responses(process_response(tasks), :ok)
  end

  def search_cost
    costs = PayrollLog.search_cost(params[:cc_name], params[:cc_code], current_user.company_id, params[:page], params[:per_page])
    responses(process_response(costs), :ok)
  end

  def search_employee
    entities = PayrollLog.search_employee(params[:employee_name], params[:employee_code], 
      params[:page], params[:per_page])
    responses(process_response(entities), :ok)
  end

  def delete_employee_to_payment

    PayrollLog.delete_employee_to_payment(params[:employee_id], params[:payroll_history_id])

    if PayrollEmployee.where("payroll_employees.employee_id = ? AND payroll_employees.payroll_history_id = ?", 
      params[:employee_id], params[:payroll_history_id]).exists?
      render :json => {:data => 'true'}
    else 
      render :json => {:data => 'false', :status => :unprocessable_entity}
    end
  end

  def get_history_json
    history = PayrollLog.employees_data(params[:id])
    respond_to do |format|
      format.json { render json: history, status: :ok }
    end
  end

  def get_employees
    ids = params[:employee_ids].scan( /\d+/ )
    entities = PayrollLog.get_employee_list(ids)
    respond_to do |format|
      format.json { render json: entities, status: :ok }
    end
  end

  def set_custom_update
    respond_to do |format|
      if PayrollHistory.update(params['data'].keys, params['data'].values)
        format.json { head :no_content }
      else
        format.json { render status: :unprocessable_entity }
      end
    end
  end

end
