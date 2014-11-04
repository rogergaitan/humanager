class OtherPaymentsController < ApplicationController

  before_filter :resources, :only => [:new, :edit]

  # GET /other_payments
  # GET /other_payments.json
  def index
    @other_payments = OtherPayment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @other_payments }
    end
  end

  # GET /other_payments/1
  # GET /other_payments/1.json
  def show
    @other_payment = OtherPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @other_payment }
    end
  end

  # GET /other_payments/new
  # GET /other_payments/new.json
  def new
    @other_payment = OtherPayment.new
    @employee_ids = []

    @other_payment.other_payment_employees.where('state=1').select('employee_id').each do |e|
      @employee_ids << e['employee_id']
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @other_payment }
    end
  end

  # GET /other_payments/1/edit
  def edit
    @other_payment = OtherPayment.find(params[:id])
    @employee_ids = []
    @objectHidden = [] # They are the ids that are hidden from view
    @object = [] # Are the ids that can't be deleted

    @other_payment.other_payment_employees.each do |pe|
      if pe.state
        @employee_ids << pe.employee_id
      else
        @objectHidden << "#{pe.employee_id}"
      end

      unless pe.other_payment_payments.empty?
        # if there are records.
        @object << "#{de.employee_id}"
      end
    end

  end

  # POST /other_payments
  # POST /other_payments.json
  def create
    @other_payment = OtherPayment.new(params[:other_payment])

    respond_to do |format|
      if @other_payment.save
        format.html { redirect_to @other_payment, notice: 'Other payment was successfully created.' }
        format.json { render json: @other_payment, status: :created, location: @other_payment }
      else
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
            otherPaymentEmployee = OtherPaymentEmployee.new
            otherPaymentEmployee.other_payment_id = params[:id]
            otherPaymentEmployee.employee_id = pe[1]["employee_id"]
            otherPaymentEmployee.calculation = pe[1]["calculation"]
            otherPaymentEmployee.state = 1
            otherPaymentEmployee.save
          end
        else
          # Old
          otherPaymentEmployee = OtherPaymentEmployee.find(pe[1]["id"])
          if to_bool( pe[1]["_destroy"] ) # Change status
            unless otherPaymentEmployee.other_payment_payments.empty?
              # if there are records.
              otherPaymentEmployee.state = 0
            else
              # No records.
              otherPaymentEmployee.destroy
            end
          else
            otherPaymentEmployee.state = 1
            otherPaymentEmployee.calculation = pe[1]["calculation"]
          end
          otherPaymentEmployee.save
        end
      end

      @other_payment.description = params[:other_payment][:description]
      @other_payment.individual = params[:other_payment][:individual]
      @other_payment.deduction_type = params[:other_payment][:deduction_type]
      @other_payment.amount = params[:other_payment][:amount]
      @other_payment.calculation_type = params[:other_payment][:calculation_type]
      @other_payment.ledger_account_id = params[:other_payment][:ledger_account_id]
      @other_payment.constitutes_salary = params[:other_payment][:constitutes_salary]      
      @other_payment.payroll_type_ids = params[:other_payment][:payroll_type_ids]

      respond_to do |format|
        if @other_payment.save
          format.html { redirect_to @other_payment, notice: 'Other payment was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @other_payment.errors, status: :unprocessable_entity }
        end
      end

      
    end # End Transaction

    # respond_to do |format|
    #   if @other_payment.update_attributes(params[:other_payment])
    #     format.html { redirect_to @other_payment, notice: 'Other payment was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: @other_payment.errors, status: :unprocessable_entity }
    #   end
    # end

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
    # @credit_accounts = LedgerAccount.credit_accounts
    @payroll_types = PayrollType.all
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
  end

end
