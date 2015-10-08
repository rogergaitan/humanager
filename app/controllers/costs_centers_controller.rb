class CostsCentersController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json, :js

  # GET /costs_centers
  # GET /costs_centers.json
  def index
    @costs_centers = CostsCenter.where(company_id: current_user.company_id)
    respond_with(@costs_centers)
  end

  def sync_cc
    @empmaest = Empmaestcc.find(:all, :select => ['iemp', 'icc', 'ncc', 'iccpadre'])
    @costs_centers = []; @syn_data = {}
    @c = 0; @ca = 0
    
    @empmaest.each do |costsCenters|
      if CostsCenter.where("icost_center = ?", costsCenters.icc).empty?
        @new_cc = CostsCenter.create(:company_id => costsCenters.iemp, :icost_center => 
                                firebird_encoding(costsCenters.icc.to_s), :name_cc => firebird_encoding(costsCenters.ncc.to_s), 
                                :icc_father => firebird_encoding(costsCenters.iccpadre.to_s))
        if @new_cc.save
          @costs_centers << @new_cc
          @c += 1
        else
          @new_cc.errors.each do |error|
            Rails.logger.error "Error creando centro de costos: #{costsCenters.icc}"
          end
        end
      else
        # UPDATE
        @update_cc = CostsCenter.find_by_icost_center(costsCenters.icc)
        params[:costsCenter] = { :company_id => costsCenters.iemp, :name_cc => firebird_encoding(costsCenters.ncc.to_s), 
                                :icc_father => firebird_encoding(costsCenters.iccpadre.to_s) }
        if @update_cc.update_attributes(params[:costsCenter])
          @ca += 1
        end
      end
    end

    @syn_data[:costscenters] = @costs_centers
    @syn_data[:notice] = ["#{t('helpers.titles.sync').capitalize}: #{@c} #{t('helpers.titles.tasksfb_update')}: #{@ca}"]
    respond_to do |format|
      format.json { render json: @syn_data}
    end
  end

  def load_cc
    @namesIds = CostsCenter.where("company_id = ? and icost_center != '' ", current_user.company_id)
    respond_to do |format|
      format.json { render json: @namesIds }
    end
  end

  def get_parent_info
    @cc_child ||= CostsCenter.find(:all, :select =>['icost_center','icc_father', 'name_cc', 'iaccount'])
  end

  # Search for Costs Centers
  def fetch_cc
    #@cc = CostsCenter.all
    @cc = CostsCenter.where(company_id: current_user.company_id)
    respond_with(@cc, :only => [:id, :icost_center, :name_cc])
  end

end
