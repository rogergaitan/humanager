class DetailPersonnelActionsController < ApplicationController
  load_and_authorize_resource
  # GET /detail_personnel_actions
  # GET /detail_personnel_actions.json
  def index
    @detail_personnel_actions = DetailPersonnelAction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @detail_personnel_actions }
    end
  end

  # GET /detail_personnel_actions/1
  # GET /detail_personnel_actions/1.json
  def show
    @detail_personnel_action = DetailPersonnelAction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @detail_personnel_action }
    end
  end

  # GET /detail_personnel_actions/new
  # GET /detail_personnel_actions/new.json
  def new
    @detail_personnel_action = DetailPersonnelAction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @detail_personnel_action }
    end
  end

  # GET /detail_personnel_actions/1/edit
  def edit
    @detail_personnel_action = DetailPersonnelAction.find(params[:id])
  end

  # POST /detail_personnel_actions
  # POST /detail_personnel_actions.json
  def create
    @detail_personnel_action = DetailPersonnelAction.new(params[:detail_personnel_action])

    respond_to do |format|
      if @detail_personnel_action.save
        format.html { redirect_to @detail_personnel_action, notice: 'Detail personnel action was successfully created.' }
        format.json { render json: @detail_personnel_action, status: :created, location: @detail_personnel_action }
      else
        format.html { render action: "new" }
        format.json { render json: @detail_personnel_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /detail_personnel_actions/1
  # PUT /detail_personnel_actions/1.json
  def update
    @detail_personnel_action = DetailPersonnelAction.find(params[:id])

    respond_to do |format|
      if @detail_personnel_action.update_attributes(params[:detail_personnel_action])
        format.html { redirect_to @detail_personnel_action, notice: 'Detail personnel action was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @detail_personnel_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /detail_personnel_actions/1
  # DELETE /detail_personnel_actions/1.json
  def destroy
    @detail_personnel_action = DetailPersonnelAction.find(params[:id])
    @detail_personnel_action.destroy

    respond_to do |format|
      format.html { redirect_to detail_personnel_actions_url }
      format.json { head :no_content }
    end
  end
end
