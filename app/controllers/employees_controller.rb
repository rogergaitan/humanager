class EmployeesController < ApplicationController
  load_and_authorize_resource
  before_filter :get_address_info, :only => [:new, :edit]
  before_filter :get_employee_info, :only => [:new, :edit]
  before_filter :set_employee_superior_and_departments, :only => [:index, :search]
  
  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(Employee, params[:id])
  end
  
  respond_to :json, :html, :js
  
  # GET /employees 
  # GET /employees.json
  def index
    @employees = Employee.paginate(:page => params[:page], :per_page => 15).includes(:entity, :department).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = Employee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
    @employee = Employee.new
    @entity = @employee.build_entity
    @employee.build_photo
    @entity.telephones.build
    @entity.emails.build
    @entity.addresses.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = Employee.find(params[:id])
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.find(params[:id])
    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        format.html { redirect_to employees_path, notice: 'Empleado actualizado correctamente.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync
    abanits = Abanit.where("bempleado = ?", 'T').find(:all, :select => ['init', 'ntercero', 'napellido'])

    c = 0
    ca = 0
    @syn_data = {}

    abanits.each do |employee|

      full_name = employee.ntercero
      last_name = employee.napellido

      if last_name.empty?
        last_name = 'nr'
      end

      if Entity.where("entityid = ?", employee.init).empty?

        new_employee = Employee.new
        entity = new_employee.build_entity(:name => firebird_encoding(full_name.to_s), 
                                              :surname => firebird_encoding(last_name.to_s), 
                                              :entityid => employee.init)
        entity.telephones.build
        new_employee.build_photo
        entity.emails.build
        entity.addresses.build

        if new_employee.save
          c += 1
        else
          new_employee.errors.each do |error|
            Rails.logger.error "Error creando empleado: #{employee.init}, el nombre no ha sido especificado"
          end
        end
      else
        # UPDATE
        @update_entity = Entity.find_by_entityid(employee.init)
        params[:entity] = { :name => firebird_encoding(full_name.to_s), :surname => firebird_encoding(last_name.to_s) }
        if @update_entity.update_attributes(params[:entity])
          ca += 1
        end
      end
    end

    @syn_data[:notice] = ["#{t('helpers.titles.sync').capitalize}: #{c} #{t('helpers.titles.tasksfb_update')}: #{ca}"]
    respond_to do |format|
      format.json { render json: @syn_data, :include => :entity }
    end
  end

  def splitname(splitname)
    full_name = {}
    if splitname.count < 4
      full_name[:name] = splitname.first
      full_name[:surname] = splitname[1, 3].join(" ")
    else
      n = splitname.count - 2
      full_name[:name] = splitname[0, n].join(" ")
      full_name[:surname] = splitname[n, splitname.count].join(" ")     
    end
    full_name
  end
  
  def load_employees
    @employees = Employee.all
    respond_to do |format|
      format.json { render json: @employees, :include => :entity }
    end
  end
  
  def get_address_info
     @province ||= Province.find(:all, :select =>['id','name'])
     @canton ||= Canton.find(:all, :select =>['id','name', 'province_id'])
     @district ||= District.find(:all, :select =>['id','name', 'canton_id'])
  end
   
  def get_employee_info
     @department = Department.find(:all, :select =>['id','name'])
     @occupation = Occupation.find(:all, :select =>['id','name'])
     @payment_frequency = PaymentFrequency.find(:all, :select =>['id','name'])
     @mean_of_payment = MeansOfPayment.find(:all, :select =>['id','name'])
     @position = Position.find(:all, :select =>['id','position'])
     @superior = Employee.all
     @payment_unit = Employee.all_payment_unit
     @payroll_type = Employee.all_payroll_type(current_user.company_id)
     @currencies = Currency.all
  end

  def search
    @employees = Employee.search(params[:search_id], params[:search_name], params[:search_surname], 
      params[:search_department], params[:search_entities], params[:page], params[:per_page])

    respond_with @employees
  end

  def search_all
    @employees = Employee.paginate(:page => params[:page], :per_page => 15).includes(:entity, :department).all
    respond_with @employees
  end

  def load_em
    @em = Entity.joins(:employee).select('employees.id, entities.name, entities.surname')
    respond_to do |format|
      format.json { render json: @em }
    end
  end

  def search_employee_by_id
    respond_with Employee.search_employee_by_id(params[:search_id])
  end

  def search_employee_by_code
    respond_with Employee.search_employee_by_code(params[:search_code])
  end

  def search_employee_by_name
    respond_with Employee.search_employee_by_name(params[:search_name])
  end
  
  private
  
    def set_employee_superior_and_departments
      @employees_s = Employee.superior
      @all_departments = Employee.all_departments    
    end

end
