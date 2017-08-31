class DeductionsController < ApplicationController
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit, :create, :update]
  
  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Deduction, params[:id])
  end
  
  before_filter :set_currencies, :only => [:edit, :new, :create, :update]

  respond_to :html, :json, :js

  # GET /deductions
  # GET /deductions.json
  def index
    @deductions = Deduction.where('company_id = ?', current_user.company_id)
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
      @deduction = Deduction.find(params[:id])
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
    @employee_ids = []
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
    @deduction = Deduction.find(params[:id])
    respond_to do |format|
      if @deduction.update_attributes(params[:deduction])
        format.html { redirect_to deductions_path, notice: 'Deducción actualizada correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deduction.errors, status: :unprocessable_entity }
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
  end
  
  private
  
    def set_currencies
      @currencies = Currency.all
    end
  
end
