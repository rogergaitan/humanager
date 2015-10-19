class OtherPaymentsController < ApplicationController
  #load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit, :create]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(OtherPayment, params[:id])
  end

  respond_to :html, :json, :js

  # GET /other_payments
  # GET /other_payments.json
  def index
    @other_payments = OtherPayment.where('state = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'])
        .paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.html
      format.json { render json: @other_payments }
    end
  end

  # GET /other_payments/new
  # GET /other_payments/new.json
  def new
    @other_payment = OtherPayment.new
    objects_employees(@other_payment)

    @other_payment.other_payment_employees.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @other_payment }
    end
  end

  # GET /other_payments/1/edit
  def edit
    begin
      @other_payment = OtherPayment.where(:state => CONSTANTS[:PAYROLLS_STATES]['ACTIVE'])
          .find(params[:id])
      objects_employees(@other_payment)
    rescue
      respond_to do |format|
        format.html { redirect_to( other_payments_path, notice: t('.notice.no_results')) }
      end
    end
  end

  # POST /other_payments
  # POST /other_payments.json
  def create
    params[:other_payment][:payroll_ids].reject!{|a| a==""}
    @other_payment = OtherPayment.new(params[:other_payment])

    respond_to do |format|
      if @other_payment.save
        format.html { redirect_to other_payments_path, notice: 'Other payment was successfully created.' }
        format.json { render json: @other_payment, status: :created, location: @other_payment }
      else
        objects_employees(@other_payment)
        format.html { render action: "new" }
        format.json { render json: @other_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /other_payments/1
  # PUT /other_payments/1.json
  def update
    
    ActiveRecord::Base.transaction do

      @other_payment = OtherPayment.find(params[:id])

      params[:other_payment][:other_payment_employees_attributes].each do |pe|
        if pe[1]["id"].nil?
          # New
          unless to_bool(pe[1]["_destroy"])
            other_payment_employee = OtherPaymentEmployee.new
            other_payment_employee.other_payment_id = params[:id]
            other_payment_employee.employee_id = pe[1]["employee_id"]
            other_payment_employee.calculation = pe[1]["calculation"]
            other_payment_employee.completed = false
            other_payment_employee.save
          end
        else
          # Old
          other_payment_employee = OtherPaymentEmployee.find(pe[1]["id"])
          if to_bool( pe[1]["_destroy"] ) # Change status
            unless other_payment_employee.other_payment_payments.empty?
              # if there are records.
              other_payment_employee.completed = true
            else
              # No records.
              other_payment_employee.destroy
            end
          else
            other_payment_employee.completed = false
            other_payment_employee.calculation = pe[1]["calculation"]
          end
          other_payment_employee.save
        end
      end

      @other_payment.description = params[:other_payment][:description]
      @other_payment.individual = params[:other_payment][:individual]
      @other_payment.deduction_type = params[:other_payment][:deduction_type]
      @other_payment.amount = params[:other_payment][:amount]
      @other_payment.calculation_type = params[:other_payment][:calculation_type]
      @other_payment.ledger_account_id = params[:other_payment][:ledger_account_id]
      @other_payment.costs_center_id = params[:other_payment][:costs_center_id]
      @other_payment.constitutes_salary = params[:other_payment][:constitutes_salary]      
      @other_payment.payroll_type_ids = params[:other_payment][:payroll_type_ids]
      @other_payment.payroll_ids = params[:other_payment][:payroll_ids]

      respond_to do |format|
        if @other_payment.save
          format.html { redirect_to other_payments_path, notice: 'Other payment was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @other_payment.errors, status: :unprocessable_entity }
        end
      end 
    end # End Transaction
  end

  # DELETE /other_payments/1
  # DELETE /other_payments/1.json
  def destroy
    @other_payment = OtherPayment.find(params[:id])
    @other_payment.destroy

    respond_to do |format|
      format.html { redirect_to other_payments_url }
      format.json { head :no_content }
    end
  end

  def resources
    @debit_accounts = LedgerAccount.debit_accounts
    @payroll_types = PayrollType.all
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
  end

  # Get a other payment object and search all ids' employees and
  # check if is possible deleted
  def objects_employees(other_payment)
    @employee_ids = []
    @object_hidden = [] # They are the ids that are hidden from view
    @object = [] # Are the ids that can't be deleted

    other_payment.other_payment_employees.each do |pe|
      unless pe.completed
        @employee_ids << pe.employee_id
      else
        @object_hidden << "#{pe.employee_id}"
      end

      unless pe.other_payment_payments.empty?
        # if there are records.
        @object << "#{pe.employee_id}"
      end
    end
  end

end
