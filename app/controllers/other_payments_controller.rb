class OtherPaymentsController < ApplicationController
  before_filter :set_other_payment, only: [:edit, :update, :destroy]
  load_and_authorize_resource
  before_filter :resources, :only => [:new, :edit, :create, :update]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(OtherPayment, params[:id])
  end

  respond_to :html, :json, :js

  # GET /other_payments
  # GET /other_payments.json
  def index
    @other_payments = OtherPayment.where(:company_id => current_user.company_id)
      .paginate(:page => params[:page], :per_page => 15)

    respond_to do |format|
      format.html
      format.json { render json: @other_payments }
      format.js { render :index }
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
    @other_payment = OtherPayment.new( params[:other_payment] )

    respond_to do |format|
      if @other_payment.save
        format.html { redirect_to other_payments_path, notice: 'Otro pago creado correctamente.' }
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
    respond_to do |format|
      if @other_payment.update_attributes(params[:other_payment])
        format.html { redirect_to other_payments_path, notice: 'Otro pago actualizado correctamente.' }
        format.json { head :no_content }
      else
        objects_employees(@other_payment)
        format.html { render action: "edit" }
        format.json { render json: @other_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /other_payments/1
  # DELETE /other_payments/1.json
  def destroy
    @other_payment.destroy

    respond_to do |format|
      format.html { redirect_to other_payments_url }
      format.json { head :no_content }
    end
  end
  
  def search
    @other_payments = OtherPayment.search params[:other_payment_type], params[:calculation_type], params[:state],
                                              current_user.company_id, params[:page]
    respond_to do |format|
      format.js { render :index }
    end
  end

  def resources
    @debit_accounts = LedgerAccount.debit_accounts
    @payroll_types = PayrollType.where company_id: current_user.company_id
    @employees = Employee.order_employees
    @department = Department.all
    @superior = Employee.superior
    @currencies = Currency.all
  end

  # Get a other payment object and search all ids' employees and
  # check if is possible deleted
  def objects_employees(other_payment)
    @employee_ids = []
    @employees_hidden = [] # They are the ids that are hidden from view
    @detail_payments = [] # Are the ids that can't be deleted

    other_payment.other_payment_employees.each do |pe|
      unless pe.completed
        @employee_ids << pe.employee_id
      else
        @employees_hidden << "#{pe.employee_id}"
      end

      unless pe.other_payment_payments.empty?
        # if there are records.
        @detail_payments << "#{pe.employee_id}"
      end
    end
    # binding.pry
  end
  
  private

  def set_other_payment
    @other_payment = OtherPayment.find_by_id_and_company_id params[:id], current_user.company_id
    rescue ActiveRecord::RecordNotFound
    redirect_to other_payments_path, notice: "El registro de otro pago no existe."
  end
end
