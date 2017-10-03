class WorkBenefitsController < ApplicationController
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit, :create]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(WorkBenefit, params[:id])
  end

  respond_to :html, :json, :js
  # GET /work_benefits
  # GET /work_benefits.json
  def index
    @work_benefits = WorkBenefit.where('company_id = ?', current_user.company_id)
        .paginate(:page => params[:page], :per_page => 15)
        .includes(:credit, :debit)
    respond_with(@work_benefits)
  end

  # GET /work_benefits/new
  # GET /work_benefits/new.json
  def new
    @work_benefit = WorkBenefit.new

    respond_with(@work_benefit)
  end

  # GET /work_benefits/1/edit
  def edit
    begin
      @work_benefit = WorkBenefit.find params[:id]
    rescue
      respond_to do |format|
        format.html { redirect_to( work_benefits_path, notice: t('.notice.no_results')) }
      end
    end
  end

  # POST /work_benefits
  # POST /work_benefits.json
  def create
    @work_benefit = WorkBenefit.new(params[:work_benefit].except(:employee_ids))
    respond_to do |format|
      if @work_benefit.save
        format.html { redirect_to action: :index }
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
    @work_benefit = WorkBenefit.find params[:id]
    respond_to do |format|
      if @work_benefit.update_attributes params[:work_benefit].except(:employee_ids)
        format.html { redirect_to action: :index }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @work_benefit.errors, status: :unprocessable_entity }
      end
    end 
  end

  # DELETE /work_benefits/1
  # DELETE /work_benefits/1.json
  def destroy
    @work_benefit = WorkBenefit.find(params[:id])

    if @work_benefit.employee_benefits.empty?
      # There are no records.
      @work_benefit.destroy
      message = t('.notice.successfully_deleted')
    else
      work_benefit_with_payments = @work_benefit.employee_benefits.each do |eb|
        unless eb.work_benefits_payments.empty?
          true
        end
      end

      if work_benefit_with_payments
        # There are no records.
        @work_benefit.destroy
        message = t('.notice.successfully_deleted')
      else
        @work_benefit.state = CONSTANTS[:PAYROLLS_STATES]['COMPLETED']
        @work_benefit.save
        message = t('.notice.can_be_deleted')
      end
    end
    
    respond_to do |format|
      format.html { redirect_to work_benefits_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  def fetch_debit_accounts
    @debit_accounts = LedgerAccount.debit_accounts.limit 0
    
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
    @cost_center = CostsCenter.where(company_id: current_user.company_id)
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
    @cost_center = WorkBenefit.search_cost_center(params[:search_cost_center_name], current_user.company_id, params[:page], params[:per_page])
    respond_with @cost_center
  end

  def search
    @work_benefits = WorkBenefit.search params[:work_benefits_type], params[:calculation_type], params[:state], 
                                          current_user.company_id, params[:page]
    
    respond_to do |format|
      format.js { render :index }
    end
  end
  
  def resources
    @debit_accounts = LedgerAccount.debit_accounts
    @credit_accounts = LedgerAccount.credit_accounts
    @cost_centers = CostsCenter.where(company_id: current_user.company_id)
    @payroll_types = PayrollType.where(company_id: current_user.company_id)
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
    @currencies = Currency.all
    @employee_ids = []

    @work_benefit.employee_benefits.where('completed = ?', true).select('employee_id').each do |e|
      @employee_ids << e['employee_id']
    end
  end
  
end
