class OtherSalariesController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json
  before_filter :resources, :only => [:new, :edit]
  before_filter :accounts, :only => [:new, :edit]
  before_filter :get_account, :only => [:edit, :update, :destroy]
  
  def get_account
    @other_salary = OtherSalary.find(params[:id])
  end

  def index
    @other_salaries = OtherSalary.paginate(:page => params[:page], :per_page => 15)
    respond_with(@other_salaries)
  end

  # GET /other_salaries/1
  # GET /other_salaries/1.json
  def show
    @other_salary = OtherSalary.find(params[:id])
    respond_with(@other_salary, :include => {:ledger_account => { :only => [:id, :naccount] }})
  end

  # GET /other_salaries/new
  # GET /other_salaries/new.json
  def new
    @other_salary = OtherSalary.new
    respond_with(@other_salary)
  end

  # GET /other_salaries/1/edit
  def edit
  end

  # POST /other_salaries
  # POST /other_salaries.json
  def create
    @other_salary = OtherSalary.new(params[:other_salary])

    respond_to do |format|
      if @other_salary.save
        format.html { redirect_to @other_salary, notice: 'Other salary was successfully created.' }
        format.json { render json: @other_salary, status: :created, location: @other_salary }
      else
        format.html { render action: "new" }
        format.json { render json: @other_salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /other_salaries/1
  # PUT /other_salaries/1.json
  def update

    respond_to do |format|
      if @other_salary.update_attributes(params[:other_salary])
        format.html { redirect_to @other_salary, notice: 'Other salary was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @other_salary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /other_salaries/1
  # DELETE /other_salaries/1.json
  def destroy
    @other_salary.destroy

    respond_to do |format|
      format.html { redirect_to other_salaries_url }
      format.json { head :no_content }
    end
  end
  
    #Search for employees
  def fetch_employees
    @employees = Employee.includes(:entity).order_employees
    respond_with(@employees, :only => [:id, :employee_id, :department_id], :include => {:entity => {:only => [:name, :surname]} })
  end
  
  def accounts
    @cuenta_contable = LedgerAccount.all
  end

  def resources
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
  end

end
