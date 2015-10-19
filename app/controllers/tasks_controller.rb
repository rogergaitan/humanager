class TasksController < ApplicationController
  load_and_authorize_resource
  respond_to :html, :json, :js

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.order("itask ASC").paginate(:page => params[:page], :per_page => 10)
    respond_with(@tasks)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
    respond_with(@task)
  end

  def tasksfb
    labmaests = Labmaest.find( :all, 
                                :select => ['iactividad', 'ilabor', 'nlabor', 'icuenta', 'mcostolabor', 'nunidad'] )

    c = 0
    ca = 0
    @tasks_fb = {}

    labmaests.each  do |task|
      if Task.where("itask = ?", task.ilabor).empty?
        new_task = Task.new(:iactivity => task.iactividad, :itask => task.ilabor, 
          :ntask => firebird_encoding(task.nlabor), :iaccount => task.icuenta, 
          :mlaborcost => task.mcostolabor, :nunidad => task.nunidad)

        if new_task.save
          c +=  1
        else
          new_task.er.each do |error|
            Rails.logger.error "Error Creating task: #{task.ilabor}, Description: #{error}"
          end
        end
      else
        update_task = Task.find_by_itask(task.ilabor)
        params[:task] = { :iactivity => task.iactividad, :ntask => firebird_encoding(task.nlabor),
                    :iaccount => task.icuenta, :mlaborcost => task.mcostolabor, :nunidad => task.nunidad }

        if update_task.update_attributes(params[:task])
          ca += 1
        end
      end
    end
    
    @tasks_fb[:notice] =  ["#{t('helpers.titles.tasksfb')}: #{c} #{t('helpers.titles.tasksfb_update')}: #{ca}"]
    respond_to do |format|
      format.json {render json: @tasks_fb }
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

end