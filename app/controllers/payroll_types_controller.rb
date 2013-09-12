class PayrollTypesController < ApplicationController
  respond_to :html, :json
  # GET /payroll_types
  # GET /payroll_types.json
  def index
    @payroll_types = PayrollType.where(:state => 1).paginate(:page => params[:page], :per_page => 15)
    respond_with(@payroll_types)
  end

  # GET /payroll_types/1
  # GET /payroll_types/1.json
  def show
    @payroll_type = PayrollType.find(params[:id])
    respond_with(@payroll_type)
  end

  # GET /payroll_types/new
  # GET /payroll_types/new.json
  def new
    @payroll_type = PayrollType.new
    respond_with(@payroll_type)
  end

  # GET /payroll_types/1/edit
  def edit
    @payroll_type = PayrollType.find(params[:id])
  end

  # POST /payroll_types
  # POST /payroll_types.json
  def create
    @payroll_type = PayrollType.new(params[:payroll_type])

    respond_to do |format|
      if @payroll_type.save
        format.html { redirect_to @payroll_type, notice: 'Payroll type was successfully created.' }
        format.json { render json: @payroll_type, status: :created, location: @payroll_type }
      else
        format.html { render action: "new" }
        format.json { render json: @payroll_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payroll_types/1
  # PUT /payroll_types/1.json
  def update
    @payroll_type = PayrollType.find(params[:id])

    respond_to do |format|
      if @payroll_type.update_attributes(params[:payroll_type])
        format.html { redirect_to @payroll_type, notice: 'Payroll type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payroll_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payroll_types/1
  # DELETE /payroll_types/1.json
  def destroy
    @payroll_type = PayrollType.find(params[:id])

    if Payroll.find_by_payroll_type_id(params[:id]).nil?
      @payroll_type.destroy
    else
      @payroll_type.state = 0
      @payroll_type.save
    end

    respond_to do |format|
      format.html { redirect_to payroll_types_url }
      format.json { head :no_content }
    end
  end
end
