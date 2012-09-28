class OccupationsController < ApplicationController
  # GET /occupations
  # GET /occupations.json
  def index
    @occupations = Occupation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @occupations }
    end
  end

  # GET /occupations/1
  # GET /occupations/1.json
  def show
    @occupation = Occupation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @occupation }
    end
  end

  # GET /occupations/new
  # GET /occupations/new.json
  def new
    @occupation = Occupation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @occupation }
    end
  end

  # GET /occupations/1/edit
  def edit
    @occupation = Occupation.find(params[:id])
  end

  # POST /occupations
  # POST /occupations.json
  def create
    @occupation = Occupation.new(params[:occupation])

    respond_to do |format|
      if @occupation.save
        format.html { redirect_to @occupation, notice: 'Occupation was successfully created.' }
        format.json { render json: @occupation, status: :created, location: @occupation }
      else
        format.html { render action: "new" }
        format.json { render json: @occupation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /occupations/1
  # PUT /occupations/1.json
  def update
    @occupation = Occupation.find(params[:id])

    respond_to do |format|
      if @occupation.update_attributes(params[:occupation])
        format.html { redirect_to @occupation, notice: 'Occupation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @occupation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /occupations/1
  # DELETE /occupations/1.json
  def destroy
    @occupation = Occupation.find(params[:id])
    @occupation.destroy

    respond_to do |format|
      format.html { redirect_to occupations_url }
      format.json { head :no_content }
    end
  end
end
