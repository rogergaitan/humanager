class WorkBenefitsController < ApplicationController
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
    respond_with(@work_benefit)
  end

  # GET /work_benefits/1/edit
  def edit
    @work_benefit = WorkBenefit.find(params[:id])
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

    respond_to do |format|
      if @work_benefit.update_attributes(params[:work_benefit])
        format.html { redirect_to @work_benefit, notice: 'Work benefit was successfully updated.' }
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
    @work_benefit.destroy

    respond_to do |format|
      format.html { redirect_to work_benefits_url }
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
