class CostsCentersController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json, :js

  # GET /costs_centers
  # GET /costs_centers.json
  def index
    @costs_centers = CostsCenter.where(company_id: current_user.company_id)
    respond_with(@costs_centers)
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
