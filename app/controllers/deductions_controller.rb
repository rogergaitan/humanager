class DeductionsController < ApplicationController
  before_filter :resources, :only => [:new, :edit]
  respond_to :html, :json

  # GET /deductions
  # GET /deductions.json
  def index
    @deductions = Deduction.paginate(:page => params[:page], :per_page => 15)
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
    respond_with(@deduction)
  end

  # GET /deductions/1/edit
  def edit
    @deduction = Deduction.find(params[:id])
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

    respond_to do |format|
      if @deduction.update_attributes(params[:deduction])
        format.html { redirect_to @deduction, notice: 'Deduction was successfully updated.' }
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
    @deduction.destroy

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

  def resources
    @credit_account = LedgerAccount.credit_accounts
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
  end

end
