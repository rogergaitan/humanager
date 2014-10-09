class WorkBenefitsController < ApplicationController
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit]
  respond_to :html, :json, :js
  # GET /work_benefits
  # GET /work_benefits.json
  def index
    @work_benefits = WorkBenefit.paginate(:page => params[:page], :per_page => 15).includes(:credit, :debit)
    respond_with(@work_benefits)
  end

  # GET /work_benefits/1
  # GET /work_benefits/1.json
  def show
    @work_benefit = WorkBenefit.find(params[:id])
    respond_with(@work_benefit)
  end

  # GET /work_benefits/new
  # GET /work_benefits/new.json
  def new
    @work_benefit = WorkBenefit.new

    @employee_ids = []

    @work_benefit.employee_benefits.where('state=1').select('employee_id').each do |e|
      @employee_ids << e['employee_id']
    end

    respond_with(@work_benefit)
  end

  # GET /work_benefits/1/edit
  def edit
    @work_benefit = WorkBenefit.find(params[:id])

    @employee_ids = []

    @work_benefit.employee_benefits.where('state=1').select('employee_id').each do |e|
      @employee_ids << e['employee_id']
    end
  end

  # POST /work_benefits
  # POST /work_benefits.json
  def create
    @work_benefit = WorkBenefit.new(params[:work_benefit])

    respond_to do |format|
      if @work_benefit.save
        format.html { redirect_to @work_benefit, notice: 'Work benefit was successfully created.' }
        format.json { render json: @work_benefit, status: :created, location: @work_benefit }
      else
        format.html { render action: "new" }
        format.json { render json: @work_benefit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /work_benefits/1
  # PUT /work_benefits/1.json
  def update
    @work_benefit = WorkBenefit.find(params[:id])

    current_employees = []
    delete_employees = []
    add_employees = []
    list_employees = params[:work_benefit][:employee_ids].to_a
    
    EmployeeBenefit.where('work_benefit_id = ?', params[:id]).select('employee_id').each do |id|
      employee_id = id['employee_id']
      current_employees << "#{employee_id}"
    end

    delete_employees = current_employees - list_employees

    if delete_employees.length > 0
      # Here delete or update state work benefits
      delete_employees.each do |id_employee|

        eb = EmployeeBenefit.find_by_work_benefit_id_and_employee_id(params[:id], id_employee)   
      
        if eb.work_benefits_payments.empty?
          # No there are records.
          eb.delete
        else
          # if there are records.
          eb.state = 0
          eb.save
        end
      end # End each delete_employees
    else
      # Here add new work benefits what not exist into the DB
      add_employees = list_employees - current_employees
      add_employees.delete("")
      list_employees.delete("")

      if add_employees.length > 0
        add_employees.each do |new_id|
          unless  new_id.empty?
            new_employee_benefit = EmployeeBenefit.new
            new_employee_benefit.work_benefit_id = params[:id]
            new_employee_benefit.employee_id = new_id
            new_employee_benefit.state = 1
            new_employee_benefit.save
          end
        end # End eacg add_employee
      else
        # Here update state for all employees
        list_employees.each do |id_list_employee|
          benenfit = EmployeeBenefit.find_by_work_benefit_id_and_employee_id(params[:id], id_list_employee)
          benenfit.state = 1
          benenfit.save
        end # End each list_employee
      end # End if add_employees
    end # End if delete_employee.length

    @work_benefit.description = params[:work_benefit][:description]
    @work_benefit.percentage = params[:work_benefit][:percentage]
    @work_benefit.debit_account = params[:work_benefit][:debit_account]
    @work_benefit.credit_account = params[:work_benefit][:credit_account]
    @work_benefit.centro_de_costo_id = params[:work_benefit][:centro_de_costo_id]
    @work_benefit.is_beneficiary = params[:work_benefit][:is_beneficiary]
    @work_benefit.beneficiary_id = params[:work_benefit][:beneficiary_id]
    @work_benefit.payroll_type_ids = params[:work_benefit][:payroll_type_ids]

    respond_to do |format|
      if @work_benefit.save
        format.html { redirect_to @work_benefit, notice: 'Work benefit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_benefit.errors, status: :unprocessable_entity }
      end
    end # End respond_to
  end

  # DELETE /work_benefits/1
  # DELETE /work_benefits/1.json
  def destroy

    @work_benefit = WorkBenefit.find(params[:id])

    if EmployeeBenefit.find_by_work_benefit_id(params[:id]).work_benefits_payments.empty?
      # There are no records.
      @work_benefit.destroy
      message = t('.notice.successfully_deleted')
    else
      # There are records.
      #@work_benefit.state = 0
      #@work_benefit.save
      message = t('.notice.can_be_deleted')
    end
    
    respond_to do |format|
      format.html { redirect_to work_benefits_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  def fetch_debit_accounts
    @debit_accounts = LedgerAccount.debit_accounts
    respond_to do |format|
      format.json { render json: @debit_accounts }
    end
  end
  
  def fetch_credit_accounts
    @credit_accounts = LedgerAccount.credit_accounts
    respond_to do |format|
      format.json { render json: @credit_accounts }
    end
  end

  def fetch_cost_center
    @cost_center = CentroDeCosto.all
    respond_to do |format|
      format.json { render json: @cost_center }
    end
  end
  
  def fetch_employees
    @employees = Employee.includes(:entity).order_employees
    respond_to do |format|
      format.json { render json: @employees, :only => [:id, :employee_id, :department_id], :include => {:entity => {:only => [:name, :surname]} } }
    end
  end

  def fetch_payroll_type
    @fetch_payroll_type = PayrollType.all
    respond_to do |format|
      format.json { render json: @fetch_payroll_type, :only => [:id, :description] }
    end
  end

  def search_cost_center
    @cost_center = WorkBenefit.search_cost_center(params[:search_cost_center_name], params[:page], params[:per_page])
    respond_with @cost_center
  end
  
  def resources
    @debit_accounts = LedgerAccount.debit_accounts
    @credit_accounts = LedgerAccount.credit_accounts
    @payroll_types = PayrollType.all
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
  end
end
