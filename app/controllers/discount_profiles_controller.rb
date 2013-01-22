class DiscountProfilesController < ApplicationController
  # GET /discount_profiles
  # GET /discount_profiles.json
  def index
    @discount_profiles = DiscountProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discount_profiles }
    end
  end

  # GET /discount_profiles/1
  # GET /discount_profiles/1.json
  def show
    @discount_profile = DiscountProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discount_profile }
    end
  end

  # GET /discount_profiles/new
  # GET /discount_profiles/new.json
  def new
    @discount_profile = DiscountProfile.new
    @discount_profile.discount_profile_items.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discount_profile }
    end
  end

  # GET /discount_profiles/1/edit
  def edit
    @discount_profile = DiscountProfile.find(params[:id])
    @names = DiscountProfile.items_name(@discount_profile)
    @discount_profile
  end

  # POST /discount_profiles
  # POST /discount_profiles.json
  def create
    @discount_profile = DiscountProfile.new(params[:discount_profile])

    respond_to do |format|
      if @discount_profile.save
        format.html { redirect_to @discount_profile, notice: t('.activerecord.models.discount_profile').capitalize + t('.notice.successfully_created') }
        format.json { render json: @discount_profile, status: :created, location: @discount_profile }
      else
        format.html { render action: "new" }
        format.json { render json: @discount_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /discount_profiles/1
  # PUT /discount_profiles/1.json
  def update
    @discount_profile = DiscountProfile.find(params[:id])

    respond_to do |format|
      if @discount_profile.update_attributes(params[:discount_profile])
        format.html { redirect_to @discount_profile, notice: t('.activerecord.models.discount_profile').capitalize + t('.notice.successfully_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discount_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discount_profiles/1
  # DELETE /discount_profiles/1.json
  def destroy
    @discount_profile = DiscountProfile.find(params[:id])
    @discount_profile.destroy

    respond_to do |format|
      format.html { redirect_to discount_profiles_url, notice: t('.activerecord.models.discount_profile').capitalize + t('.notice.successfully_deleted') }
      format.json { head :no_content }
    end
  end
end
