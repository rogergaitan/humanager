class DeductionsController < ApplicationController
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit]
  
  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Deduction, params[:id])
  end

  respond_to :html, :json, :js

  # GET /deductions
  # GET /deductions.json
  def index
    @deductions = Deduction.where('state = ? and company_id = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'], current_user.company_id)
        .paginate(:page => params[:page], :per_page => 15)
    respond_with(@deductions, :include => :ledger_account)
  end

  # GET /deductions/new
  # GET /deductions/new.json
  def new
    @deduction = Deduction.new
    @employee_ids = []

    @deduction.deduction_employees.where('completed = ?', false).select('employee_id').each do |e|
      @employee_ids << e['employee_id']
    end

    @deduction.deduction_employees.build
    
    respond_to do |format|
      format.html
      format.json { render json: @employee }
    end
  end

  # GET /deductions/1/edit
  def edit
    begin
      @deduction = Deduction.where('state = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE']).find(params[:id])
      @object = []
      @object_hidden = []

      @deduction.deduction_employees.each do |de|
        unless de.deduction_payments.empty?
          # if there are records.
          @object << "#{de.employee_id}"
        end

        if de.completed
          @object_hidden << "#{de.employee_id}"
        end
      end

      @employee_ids = []

      @deduction.deduction_employees.where('completed = ?', false ).select('employee_id').each do |e|
        @employee_ids << e['employee_id']
      end
    rescue
      respond_to do |format|
        format.html { redirect_to( deductions_path, notice: t('.notice.no_results')) }
      end
    end
  end

  # POST /deductions
  # POST /deductions.json
  def create
    @deduction = Deduction.new(params[:deduction])
    @deduction.state = CONSTANTS[:PAYROLLS_STATES]['ACTIVE']

    respond_to do |format|
      if @deduction.save
        format.html { redirect_to action: :index }
        format.json { render json: @deduction, status: :created, location: @deduction }
      else
        format.html { render action: :new }
        format.json { render json: @deduction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deductions/1
  # PUT /deductions/1.json
  def update

    ActiveRecord::Base.transaction do
      
      @deduction = Deduction.find(params[:id])

      # Employees from the view
      params[:deduction][:deduction_employees_attributes].each do |de|
        deduction_obj = de[1]
        if deduction_obj["id"].nil?
          # New
          unless to_bool( deduction_obj["_destroy"] )
            new_deduction_employee = DeductionEmployee.new
            new_deduction_employee.deduction_id = params[:id]
            new_deduction_employee.employee_id = deduction_obj["employee_id"]
            new_deduction_employee.calculation = deduction_obj["calculation"]
            new_deduction_employee.completed = false
            new_deduction_employee.save
          end
        else
          # Old
          deduction_employee = DeductionEmployee.find( deduction_obj["id"] )
          if to_bool( deduction_obj["_destroy"] ) # Change status
            unless deduction_employee.deduction_payments.empty?
              # if there are records.
              deduction_employee.completed = true
            else
              # No records.
              deduction_employee.destroy
            end
          else
            deduction_employee.completed = false
            deduction_employee.calculation = deduction_obj["calculation"]
          end
          deduction_employee.save
        end
      end

      @deduction.description = params[:deduction][:description]
      @deduction.individual = params[:deduction][:individual]
      @deduction.deduction_type = params[:deduction][:deduction_type]
      @deduction.amount_exhaust = params[:deduction][:amount_exhaust]
      @deduction.calculation_type = params[:deduction][:calculation_type]
      @deduction.ledger_account_id = params[:deduction][:ledger_account_id]
      @deduction.is_beneficiary = params[:deduction][:is_beneficiary]
      @deduction.beneficiary_id = params[:deduction][:beneficiary_id]
      @deduction.payroll_type_ids = params[:deduction][:payroll_type_ids]

      respond_to do |format|
        if @deduction.save
          format.html { redirect_to deductions_path, notice: 'Deduction was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @deduction.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /deductions/1
  # DELETE /deductions/1.json
  def destroy
    @deduction = Deduction.find(params[:id])

    if @deduction.deduction_employees.empty?
      @deduction.destroy
      message = t('.notice.successfully_deleted')
    else
      deduction_with_payments = @deduction.deduction_employees.each do |de| 
        unless de.deduction_payments.empty?
          true
        end
      end

      if deduction_with_payments
        # There are no records.
        @deduction.destroy
        message = t('.notice.successfully_deleted')
      else
        @deduction.state = CONSTANTS[:PAYROLLS_STATES]['COMPLETED']
        @deduction.save
        message = t('.notice.can_be_deleted')
      end
    end

    respond_to do |format|
      format.html { redirect_to deductions_url, notice: message }
      format.json { head :no_content }
    end
  end

  #Search for employees
  def fetch_employees
    @employees = Employee.includes(:entity).order_employees
    respond_with(@employees, :only => [:id, :employee_id, :department_id], :include => {:entity => {:only => [:name, :surname]} })
  end

  def get_activas
    @activas = {}
    @activas[:activa] = Payroll.activas
    respond_with(@activas)
  end

  def fetch_payroll_type
    @fetch_payroll_type = PayrollType.all
    respond_to do |format|
      format.json { render json: @fetch_payroll_type, :only => [:id, :description] }
    end
  end

  def resources
    @credit_account = LedgerAccount.credit_accounts
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
    @payroll_types = PayrollType.where(company_id: current_user.company_id)
  end

end