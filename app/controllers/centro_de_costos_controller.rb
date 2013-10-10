class CentroDeCostosController < ApplicationController
  load_and_authorize_resource
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
                                firebird_encoding(centrocostos.icc.to_s), :nombre_cc => firebird_encoding(centrocostos.ncc.to_s), 
                                :icc_padre => firebird_encoding(centrocostos.iccpadre.to_s))
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
    @cc_child ||= CentroDeCosto.find(:all, :select =>['icentro_costo','icc_padre', 'nombre_cc', 'iaccount'])
   end
end