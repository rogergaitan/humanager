class PayrollsController < ApplicationController
  load_and_authorize_resource
  before_filter :get_payroll_types, :only => [:new, :edit]
  skip_before_filter :verify_authenticity_token, :only => [:close_payroll, :send_to_firebird, :get_main_calendar]
  
  respond_to :html, :json, :js

  # GET /payrolls
  # GET /payrolls.json
  def index
    logger.debug current_user.to_yaml
    #@payrolls = Payroll.all
  end

  # GET /payrolls/1
  # GET /payrolls/1.json
  def show
    @payroll = Payroll.find(params[:id])
    respond_with(@payroll)
  end

  # GET /payrolls/new
  # GET /payrolls/new.json
  def new
    @payroll = Payroll.new
    respond_with(@payroll)
  end

  # GET /payrolls/1/edit
  def edit
    @payroll = Payroll.find(params[:id])
  end

  # POST /payrolls
  # POST /payrolls.json
  def create
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

  # PUT /payrolls/1
  # PUT /payrolls/1.json
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

  # DELETE /payrolls/1
  # DELETE /payrolls/1.json
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
    @activas[:activa] = Payroll.activas(current_user.company_id)

    respond_to do |format|
      format.json { render json: @activas.to_json(include: [:payroll_type, :payroll_log, :company])}
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
    @inactivas[:inactiva] = Payroll.inactivas(current_user.company_id)

    respond_to do |format|
      format.json { render json: @inactivas.to_json(include: [:payroll_type, :payroll_log, :company])}
    end
  end

  # Obtiene todos los tipos de planillas y todas las compañias
  def get_payroll_types
    @payroll_types = PayrollType.tipo_planilla(current_user.company_id)
    @companies = Company.all
  end

  # Reabre una o un conjunto de planillas cerradas
  def reabrir
    @payroll = JSON.parse(params[:reabrir_planilla])

    @payroll.each do |planilla|
      p = Payroll.find(planilla)
      p.update_attributes(:state => true)
    end
    render :index
  end

  # Cierra una planilla y realiza los calculos necesarios
  # Closes a payroll and performs the necessary calculations
  def close_payroll
    payroll_id = params[:payroll_id]

    @result = Payroll.close_payroll(payroll_id)

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
    puts "------------"
    puts calendar.to_json
    puts "------------"
    responses(calendar, :ok)
  end

end
