class PayrollsController < ApplicationController
  respond_to :html, :json
  before_filter :get_payroll_types, :only => [:new, :edit]

  # GET /payrolls
  # GET /payrolls.json
  def index
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
    @payroll.build_payroll_log

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

  #Obtiene las planillas activas
  def get_activas
    @activas = {}
    @activas[:activa] = Payroll.activas

     respond_to do |format|
      format.json { render json: @activas.to_json(include: [:payroll_type, :payroll_log])}
    end
  end

  def load_payrolls
    @payrolls = Payroll.activas
    respond_to do |format|
      format.json { render json: @payrolls, :include => :payroll_type }
    end
  end

  #Obtiene las planillas inactivas
  def get_inactivas
    @inactivas = {}
    @inactivas[:inactiva] = Payroll.inactivas

    respond_to do |format|
      format.json { render json: @inactivas, :include => :payroll_type }
    end
  end

  #Obtiene todos los tipos de planillas
  def get_payroll_types
    @payroll_types = PayrollType.tipo_planilla
  end

  #Reabre una o un conjunto de planillas cerradas
  def reabrir
    @payroll = JSON.parse(params[:reabrir_planilla])

    @payroll.each do |planilla|
      p = Payroll.find(planilla)
      p.update_attributes(:state => true)
    end
    render :index
  end

  #Cierra una planilla y realiza los calculos de prestaciones
  def cerrar_planilla
    @payroll = JSON.parse(params[:cerrar_planilla])

    @payroll.each do |planilla|
      p = Payroll.find(planilla)
      p.update_attributes(:state => false)
    end
    render :index
  end

end
