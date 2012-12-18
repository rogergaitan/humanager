class EmployeesController < ApplicationController
  before_filter :get_address_info, :only => [:new, :edit]
  before_filter :get_employee_info, :only => [:new, :edit]
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

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(params[:employee])

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render json: @employee, status: :created, location: @employee }
      else
        format.html { render action: "new" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = Employee.find(params[:id])

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end

  def sync
    @abanits = Abanit.where("bempleado = ?", 'T').find(:all, 
                            :select => ['init', 'ntercero'])
    @c = 0 
    @syn_data = {}
    @employees = []
    @notice = []
    @abanits.each do |employee|
      if Entity.where("entityid = ?", employee.init).empty?
        full_name = splitname(firebird_encoding(employee.ntercero).split)
        @new_employee = Employee.new
        @entity = @new_employee.build_entity(:name => full_name[:name], :surname => 
                                full_name[:surname], :entityid => employee.init)
        @entity.telephones.build
        @new_employee.build_photo
        @entity.emails.build
        @entity.addresses.build
        if @new_employee.save
           @employees << @new_employee
            @c += 1
        else
          @new_employee.errors.each do |error|
            @notice << "Error creando empleado: #{employee.init}, el nombre no ha sido especificado"
          end
        end        
      end
    end
    @syn_data[:employee] = @employees
    @notice << "#{t('helpers.titles.sync').capitalize}: #{@c}"
    @syn_data[:notice] = @notice
    respond_to do |format|
        format.json { render json: @syn_data, :include => :entity}
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
     @occupation = Occupation.find(:all, :select =>['id','description'])
     @payment_frequency = PaymentFrequency.find(:all, :select =>['id','name'])
     @mean_of_payment = MeansOfPayment.find(:all, :select =>['id','name'])
     @position = Position.find(:all, :select =>['id','position'])
     @superior = Employee.all
   end
end