class TasksController < ApplicationController
  load_and_authorize_resource

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Task, params[:id])
  end
  
  before_filter :set_currencies, :only => [:edit, :update]

  respond_to :html, :json, :js

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.order("itask ASC").paginate(:page => params[:page], :per_page => 10)
    respond_with(@tasks)
  end

  # GET /provinces/1/edit
  def edit
  end

  # PUT /provinces/1
  # PUT /provinces/1.json
  def update
    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:success] = "Labor actualizada exitosamente."
        format.html { redirect_to action: :index }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def load_cc
    @namesIds = Task.all
    respond_to do |format|
      format.json { render json: @namesIds }
    end
  end

  # Search for tasks
  def fetch_tasks
    @tasks = Task.all
    respond_with(@tasks, :only => [:id, :itask, :ntask, :iaccount])
  end

  def search
    @tasks = Task.search(params[:search_code], params[:search_desc], params[:page], params[:per_page])
    respond_with @tasks
  end
  
  private
    def set_currencies
      @currencies = Currency.all  
    end
end
