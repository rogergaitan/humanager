class SupportsController < ApplicationController
  def index
    @supports = Support.all
    respond_to do |format|
      format.json { render json: @supports }
    end
  end
end
