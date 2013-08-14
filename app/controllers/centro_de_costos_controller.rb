class CentroDeCostosController < ApplicationController
  before_filter :is_login, :only => [:index, :show, :new, :edit, :create, :update, :destroy]
  before_filter :get_parent_info, :only => [:new, :edit]
  # GET /centro_de_costos
  # GET /centro_de_costos.json
  def index
    @centro_de_costos = CentroDeCosto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @centro_de_costos }
    end
  end

  # GET /centro_de_costos/1
  # GET /centro_de_costos/1.json
  def show
    @centro_de_costo = CentroDeCosto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @centro_de_costo }
    end
  end

  # GET /centro_de_costos/new
  # GET /centro_de_costos/new.json
  def new
    @centro_de_costo = CentroDeCosto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @centro_de_costo }
    end
  end

  # GET /centro_de_costos/1/edit
  def edit
    @centro_de_costo = CentroDeCosto.find(params[:id])
  end

  # POST /centro_de_costos
  # POST /centro_de_costos.json
  def create
    @centro_de_costo = CentroDeCosto.new(params[:centro_de_costo])

    respond_to do |format|
      if @centro_de_costo.save
        format.html { redirect_to @centro_de_costo, notice: 'Centro de costo was successfully created.' }
        format.json { render json: @centro_de_costo, status: :created, location: @centro_de_costo }
      else
        format.html { render action: "new" }
        format.json { render json: @centro_de_costo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /centro_de_costos/1
  # PUT /centro_de_costos/1.json
  def update
    @centro_de_costo = CentroDeCosto.find(params[:id])

    respond_to do |format|
      if @centro_de_costo.update_attributes(params[:centro_de_costo])
        format.html { redirect_to @centro_de_costo, notice: 'Centro de costo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @centro_de_costo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /centro_de_costos/1
  # DELETE /centro_de_costos/1.json
  def destroy
    @centro_de_costo = CentroDeCosto.find(params[:id])
    @centro_de_costo.destroy
    unless @centro_de_costo.errors.empty?
      notice = "El elemento que esta intentando eliminar tiene hijos asociados"
    end

    respond_to do |format|
      format.html { redirect_to centro_de_costos_url, notice: notice }
      format.json { head :no_content }
    end
  end

  def sync_cc
    @empmaest = Empmaestcc.find(:all, 
                            :select => ['iemp', 'icc', 'ncc', 'iccpadre'])
    @centro_costos = []
    @syn_data = {}
    @c = 0
    @notice = []
    @empmaest.each do |centrocostos|
      if CentroDeCosto.where("icentro_costo = ?", centrocostos.icc).empty?
        @new_cc = CentroDeCosto.create(:iempresa => centrocostos.iemp, :icentro_costo => 
                                firebird_encoding(centrocostos.icc), :nombre_cc => firebird_encoding(centrocostos.ncc), 
                                :icc_padre => firebird_encoding(centrocostos.iccpadre))
        if @new_cc.save
          @centro_costos << @new_cc
          @c += 1
        else
          @new_cc.errors.each do |error|
            @notice << "Error creando centro de costos: #{centrocostos.icc}"
          end
        end        
      end
    end
    @syn_data[:centrocostos] = @centro_costos
    @notice << "#{t('helpers.titles.sync').capitalize}: #{@c}"
    @syn_data[:notice] = @notice
    respond_to do |format|
        format.json { render json: @syn_data}
      end
  end

  def load_cc
    @namesIds = CentroDeCosto.all
    respond_to do |format|
      format.json { render json: @namesIds}
    end
  end

  def get_parent_info
    @cc_child ||= CentroDeCosto.find(:all, :select =>['icentro_costo','icc_padre', 'nombre_cc'])
   end
end