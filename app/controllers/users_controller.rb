class UsersController < ApplicationController
  respond_to :html, :json
  # before_filter :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:page => params[:page], :per_page => 15).all

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_with(@user)
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to action: "index" }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to action: "index" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      flash[:notice] = 'User was successfully deleted.'
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def usersfb
    @usersfb = Abausuario.find(:all, :select => ['nusr', 'snombre', 'sapellido', 'semail'])
    @c = 0
    @users = []
    @users_fb = {}

    @usersfb.each do |ufb|
      
      if User.where("username = ?", ufb.nusr).empty?

        @numer = randow_string
        @new_user = User.new( :username => "#{ufb.nusr}", 
                              :name => "#{ufb.snombre} #{ufb.sapellido}", 
                              :email => "#{ufb.semail}", 
                              :password => @numer, 
                              :password_confirmation => @numer )

        if @new_user.save
          @users << @new_user
          @c += 1
        else
          @new_user.errors.each do |error|
            Rails.logger.error "Error Creating User: #{ufb.nusr}, Description: #{error}";
          end
        end
      end # End if
      @users_fb[:user] = @users
      @users_fb[:notice] = "#{t('helpers.titles.tasksfb').capitalize}: #{@c}"
    end # End each usersfb

    respond_to do |format|
      format.json { render json: @users_fb }
    end
  end

  def randow_string
    value = ""; 8.times{ value << (65 + rand(25)).chr }
    return value
  end

end