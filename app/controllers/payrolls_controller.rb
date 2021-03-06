class PayrollsController < ApplicationController
  load_and_authorize_resource
  before_filter :get_payroll_types, :only => [:new, :edit, :update]
  before_filter :get_currencies, :only => [:new, :edit, :update]
  before_filter :set_company, :only => [:create, :get_activas, :get_inactivas]
  skip_before_filter :verify_authenticity_token, :only => [:close_payroll, :send_to_firebird, :get_main_calendar]
  
  respond_to :html, :json, :js

  def index
    #@payrolls = Payroll.all
  end

  def show
    @payroll = Payroll.find(params[:id])
    respond_with(@payroll)
  end

  def new
    @payroll = Payroll.new
    respond_with(@payroll)
  end

  def edit
    @payroll = Payroll.find(params[:id])
  end

  def create
    params[:payroll][:company_id] = @company.id
    @payroll = Payroll.new(params[:payroll])
    @payroll_log = @payroll.build_payroll_log
    @payroll.payroll_log.payroll_total = 0
    # @payroll_log.payroll_histories.build

    respond_to do |format|
      if @payroll.save
        format.html { redirect_to edit_payroll_log_path(@payroll.payroll_log), notice: 'Planilla creada exitosamente.' }
        format.json { render json: @payroll, status: :created, location: edit_payroll_log_path(@payroll.payroll_log) }
      else
        format.html { render action: "new" }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @payroll = Payroll.find(params[:id])

    respond_to do |format|
      if @payroll.update_attributes(params[:payroll])
        format.html { redirect_to @payroll, notice: 'Planilla modificada exitosamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payroll = Payroll.find(params[:id])
    @payroll.destroy

    respond_to do |format|
      format.html { redirect_to payrolls_url }
      format.json { head :no_content }
    end
  end

  # Obtiene las planillas activas
  def get_activas
    @activas = {}
    @activas[:activa] = Payroll.activas(@company.id)
    respond_to do |format|
      format.json { render json: @activas.to_json(include: [:payroll_type, :payroll_log, :company, :currency])}
    end
  end

  def load_payrolls
    @payrolls = Payroll.activas(current_user.company_id)
    respond_to do |format|
      format.json { render json: @payrolls, :include => :payroll_type }
    end
  end

  # Obtiene las planillas inactivas
  def get_inactivas
    @inactivas = {}
    @inactivas[:inactiva] = Payroll.inactivas(@company.id)
    respond_to do |format|
      format.json { render json: @inactivas.to_json(include: [:payroll_type, :payroll_log, :company, :currency])}
    end
  end

  # Obtiene todos los tipos de planillas y todas las compañias
  def get_payroll_types
    @payroll_types = PayrollType.tipo_planilla(current_user.company_id)
    @companies = Company.all
  end

  # Reabre una o un conjunto de planillas cerradas
  def reopen
    Payroll.reopen_payroll params[:payroll_id]
    render :index
  end

  # Cierra una planilla y realiza los calculos necesarios
  # Closes a payroll and performs the necessary calculations
  def close_payroll
    payroll_id = params[:payroll_id]
    exchange_rate = params[:exchange_rate]

    @result = Payroll.close_payroll(payroll_id, exchange_rate)

    respond_to do |format|
      format.json { render json: @result }
    end
  end

  def send_to_firebird
    payroll_id = params[:payroll_id]
    result = Payroll.send_to_firebird(payroll_id, current_user.username)

    respond_to do |format|
      if result
        format.json { render json: { 'status' => true }, status: :created }
      else
        format.json { render json: { 'status' => false }, status: :unprocessable_entity }
      end
    end
  end

  def get_main_calendar
    calendar = Payroll.get_main_calendar(params[:start], params[:end], current_user.company_id)
    responses(calendar, :ok)
  end
  
  private
  
  def get_currencies
    @currencies = Currency.all
  end

  def set_company
    code = current_user.company_id if current_user.company_id
    code = params[:payroll][:company_id] if params[:payroll] && params[:payroll][:company_id]
    @company = Company.find_by_code(code)
  end
  
end
