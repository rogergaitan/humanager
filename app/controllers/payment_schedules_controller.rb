class PaymentSchedulesController < ApplicationController
  # GET /payment_schedules
  # GET /payment_schedules.json
  def index
    @payment_schedules = PaymentSchedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payment_schedules }
    end
  end

  # GET /payment_schedules/1
  # GET /payment_schedules/1.json
  def show
    @payment_schedule = PaymentSchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @payment_schedule }
    end
  end

  # GET /payment_schedules/new
  # GET /payment_schedules/new.json
  def new
    @payment_schedule = PaymentSchedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment_schedule }
    end
  end

  # GET /payment_schedules/1/edit
  def edit
    @payment_schedule = PaymentSchedule.find(params[:id])
  end

  # POST /payment_schedules
  # POST /payment_schedules.json
  def create
    @payment_schedule = PaymentSchedule.new(params[:payment_schedule])

    respond_to do |format|
      if @payment_schedule.save
        format.html { redirect_to @payment_schedule, notice: 'Payment schedule was successfully created.' }
        format.json { render json: @payment_schedule, status: :created, location: @payment_schedule }
      else
        format.html { render action: "new" }
        format.json { render json: @payment_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payment_schedules/1
  # PUT /payment_schedules/1.json
  def update
    @payment_schedule = PaymentSchedule.find(params[:id])

    respond_to do |format|
      if @payment_schedule.update_attributes(params[:payment_schedule])
        format.html { redirect_to @payment_schedule, notice: 'Payment schedule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_schedules/1
  # DELETE /payment_schedules/1.json
  def destroy
    @payment_schedule = PaymentSchedule.find(params[:id])
    @payment_schedule.destroy

    respond_to do |format|
      format.html { redirect_to payment_schedules_url }
      format.json { head :no_content }
    end
  end
end
