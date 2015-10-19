class TypeOfPersonnelActionsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_fields, :only => [:new, :edit]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(TypeOfPersonnelAction, params[:id])
  end

  respond_to :html, :json
  # GET /type_of_personnel_actions
  # GET /type_of_personnel_actions.json
  def index
    @type_of_personnel_actions = TypeOfPersonnelAction.paginate(:page => params[:page], :per_page => 15)
    respond_with(@type_of_personnel_actions)
  end

  # GET /type_of_personnel_actions/1
  # GET /type_of_personnel_actions/1.json
  def show
    @type_of_personnel_action = TypeOfPersonnelAction.find(params[:id])
    respond_with(@type_of_personnel_action)
  end

  # GET /type_of_personnel_actions/new
  # GET /type_of_personnel_actions/new.json
  def new
    @type_of_personnel_action = TypeOfPersonnelAction.new
    respond_with(@type_of_personnel_action)
  end

  # GET /type_of_personnel_actions/1/edit
  def edit
    @type_of_personnel_action = TypeOfPersonnelAction.find(params[:id])
  end

  # POST /type_of_personnel_actions
  # POST /type_of_personnel_actions.json
  def create
    @type_of_personnel_action = TypeOfPersonnelAction.new(params[:type_of_personnel_action])

    respond_to do |format|
      if @type_of_personnel_action.save
        format.html { redirect_to @type_of_personnel_action, notice: 'Type of personnel action was successfully created.' }
        format.json { render json: @type_of_personnel_action, status: :created, location: @type_of_personnel_action }
      else
        format.html { render action: "new" }
        format.json { render json: @type_of_personnel_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /type_of_personnel_actions/1
  # PUT /type_of_personnel_actions/1.json
  def update
    @type_of_personnel_action = TypeOfPersonnelAction.find(params[:id])

    respond_to do |format|
      if @type_of_personnel_action.update_attributes(params[:type_of_personnel_action])
        format.html { redirect_to @type_of_personnel_action, notice: 'Type of personnel action was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @type_of_personnel_action.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_of_personnel_actions/1
  # DELETE /type_of_personnel_actions/1.json
  def destroy
    @type_of_personnel_action = TypeOfPersonnelAction.find(params[:id])
    @type_of_personnel_action.destroy

    respond_to do |format|
      format.html { redirect_to type_of_personnel_actions_url }
      format.json { head :no_content }
    end
  end

  def load_fields
    @fields_personnel = FieldsPersonnelAction.all  
  end

end
