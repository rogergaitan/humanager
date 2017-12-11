class PayrollTypesController < ApplicationController
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit, :update, :create]
  before_filter :set_payroll_type => [:edit, :update, :destroy]
  skip_load_and_authorize_resource :only => [:validate_description_uniqueness]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(PayrollType, params[:id])
  end

  respond_to :html, :json

  # GET /payroll_types
  # GET /payroll_types.json
  def index
    @payroll_types = PayrollType.where(:state => 1, :company_id => current_user.company_id).paginate(:page => params[:page], :per_page => 15)
    respond_with(@payroll_types)
  end

  # GET /payroll_types/new
  # GET /payroll_types/new.json
  def new
    @payroll_type = PayrollType.new
    respond_with(@payroll_type)
  end

  # GET /payroll_types/1/edit
  def edit
    @payroll_type
  end

  # POST /payroll_types
  # POST /payroll_types.json
  def create
    @payroll_type = PayrollType.new(params[:payroll_type])

    respond_to do |format|
      if @payroll_type.save
        format.html { redirect_to action: :index }
        format.json { render json: @payroll_type, status: :created, location: @payroll_type }
      else
        format.html { render action: "new" }
        format.json { render json: @payroll_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payroll_types/1
  # PUT /payroll_types/1.json
  def update
    respond_to do |format|
      if @payroll_type.update_attributes(params[:payroll_type])
        format.html { redirect_to action: :index }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payroll_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_types/1
  # DELETE /payroll_types/1.json
  def destroy
    @payroll_type.destroy
    
    message = t('.notice.successfully_deleted')
    rescue ActiveRecord::DeleteRestrictionError
      message = t('.notice.can_be_deleted')
    ensure
    respond_to do |format|
      format.html { redirect_to payroll_types_url, notice: message }
      format.json { head :no_content }
    end
  end
  
  def validate_description_uniqueness
    status = PayrollType.validate_description_uniqueness params[:id], params[:payroll_type][:description], current_user.company_id
    
    respond_to do |format|
      format.json { render nothing: true,  status: status }
    end
  end

  private

  def resources
    @bank_accounts = LedgerAccount.bank_account
    gon.employees = Employee.custom_employees
  end

  def set_payroll_type
    @payroll_type = PayrollType.find params[:id]
  end

end
