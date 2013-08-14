class DeductionsController < ApplicationController
  before_filter :is_login, :only => [:index, :show, :new, :edit, :create, :update, :destroy]
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

    respond_with(@deduction)
  end

  # GET /deductions/1/edit
  def edit
    @deduction = Deduction.find(params[:id])

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

    @deduction = Deduction.find(params[:id])
    
    current_employees = []
    delete_employees = []
    add_employees = []
    list_employees = params[:deduction][:employee_ids].to_a

    DeductionEmployee.where('deduction_id = ?', params[:id]).select('employee_id').each do |id|
      employee_id = id['employee_id']
      current_employees << "#{employee_id}"
    end

    delete_employees = current_employees - list_employees

    if delete_employees.length > 0
      # Here delete or update state deduction employees
      delete_employees.each do |id_employee|

        de = DeductionEmployee.find_by_deduction_id_and_employee_id(params[:id], id_employee)
      
        if de.deduction_payments.empty?
          # No there are records.
          de.delete
        else
          # if there are records.
          de.state = 0
          de.save
        end
      end # End each delete_employeest
    else
      # Here add new employees what not exist into the DB
      add_employees = list_employees - current_employees
      add_employees.delete("")
      list_employees.delete("")

      if add_employees.length > 0
        add_employees.each do |new_id|
          unless new_id.empty?
            new_deduction_employee = DeductionEmployee.new
            new_deduction_employee.deduction_id = params[:id]
            new_deduction_employee.employee_id = new_id
            new_deduction_employee.state = 1
            new_deduction_employee.save
          end
        end # End each add_employees
      else
        # Here update state for all employees
        list_employees.each do |id_list_employee|
          deduction = DeductionEmployee.find_by_deduction_id_and_employee_id(params[:id], id_list_employee)
          deduction.state = 1
          deduction.save
        end # End each list_employees
      end # End if add_employees.length
    end # End each delete_employees

    @deduction.description = params[:deduction][:description]
    @deduction.deduction_type = params[:deduction][:deduction_type]
    @deduction.amount_exhaust = params[:deduction][:amount_exhaust]
    @deduction.calculation_type = params[:deduction][:calculation_type]
    @deduction.calculation = params[:deduction][:calculation]
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

    # respond_to do |format|
    #   if @deduction.update_attributes(params[:deduction])
    #     format.html { redirect_to @deduction, notice: 'Deduction was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: @deduction.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /deductions/1
  # DELETE /deductions/1.json
  def destroy
      
    @deduction = Deduction.find(params[:id])

    if DeductionEmployee.find_by_deduction_id(params[:id]).deduction_payments.empty?
      # There are no records.
      @deduction.destroy
    else
      # There are records.
      @deduction.state = 0
      @deduction.save
    end

    respond_to do |format|
      format.html { redirect_to deductions_url }
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