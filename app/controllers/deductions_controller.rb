class DeductionsController < ApplicationController
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit]
  respond_to :html, :json, :js

  # GET /deductions
  # GET /deductions.json
  def index
    @deductions = Deduction.where('state = ?', 1).paginate(:page => params[:page], :per_page => 15)
    respond_with(@deductions, :include => :ledger_account)
  end

  # GET /deductions/1
  # GET /deductions/1.json
  def show
    @deduction = Deduction.find(params[:id])
    respond_with(@deduction, :include => :ledger_account)
  end

  # GET /deductions/new
  # GET /deductions/new.json
  def new
    @deduction = Deduction.new
    @employee_ids = []

    @deduction.deduction_employees.where('state=1').select('employee_id').each do |e|
      @employee_ids << e['employee_id']
    end
    #respond_with(@deduction)

    @deduction.deduction_employees.build
    
    respond_to do |format|
      format.html
      format.json { render json: @employee }
    end
  end

  # GET /deductions/1/edit
  def edit
    @deduction = Deduction.find(params[:id])

    @object = []
    @objectHidden = []

    @deduction.deduction_employees.each do |de|
      unless de.deduction_payments.empty?
        # if there are records.
        @object << "#{de.employee_id}"
      end

      unless de.state
        @objectHidden << "#{de.employee_id}"
      end

    end

    @employee_ids = []

    @deduction.deduction_employees.where('state=1').select('employee_id').each do |e|
      @employee_ids << e['employee_id']
    end
    #@credit_account = LedgerAccount.credit_accounts
  end

  # POST /deductions
  # POST /deductions.json
  def create
    @deduction = Deduction.new(params[:deduction])

    respond_to do |format|
      if @deduction.save
        format.html { redirect_to @deduction, notice: 'Deduction was successfully created.' }
        format.json { render json: @deduction, status: :created, location: @deduction }
      else
        format.html { render action: "new" }
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
        if de[1]["id"].nil?
          # New
          unless to_bool( de[1]["_destroy"] )
            new_deduction_employee = DeductionEmployee.new
            new_deduction_employee.deduction_id = params[:id]
            new_deduction_employee.employee_id = de[1]["employee_id"]
            new_deduction_employee.calculation = de[1]["calculation"]
            new_deduction_employee.state = 1
            new_deduction_employee.save
          end
        else
          # Old
          deductionEmployee = DeductionEmployee.find( de[1]["id"] )
          if to_bool( de[1]["_destroy"] ) # Change status
            unless deductionEmployee.deduction_payments.empty?
              # if there are records.
              puts "ACTUALIZA ESTADO A 0"
              deductionEmployee.state = 0
            else
              # No records.
              puts "ELIMINA EL DEDUCTION-EMPLOYEE"
              deductionEmployee.destroy
            end
          else
            puts "ACTUALIZA ESTADO A 1"
            deductionEmployee.state = 1
            deductionEmployee.calculation = de[1]["calculation"]
          end
          deductionEmployee.save
        end
      end

      # "payroll_ids"=>[""],

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
          format.html { redirect_to @deduction, notice: 'Deduction was successfully updated.' }
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

      if DeductionEmployee.find_by_deduction_id(params[:id]).deduction_payments.empty?
        # There are no records.
        @deduction.destroy
        message = t('.notice.successfully_deleted')
      else
        # There are records.
        #@deduction.state = 0
        #@deduction.save
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
    @payroll_types = PayrollType.all
  end

end