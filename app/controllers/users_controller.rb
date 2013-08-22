class UsersController < ApplicationController
  respond_to :html, :json, :js
  skip_before_filter :verify_authenticity_token, :only => [:update]

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
  # def create
  #   @user = User.new(params[:user])

  #   respond_to do |format|
  #     if @user.save
  #       flash[:notice] = 'User was successfully created.'
  #       format.html { redirect_to action: "index" }
  #       format.json { render json: @user, status: :created, location: @user }
  #     else
  #       format.html { render action: "new" }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PUT /users.1
  # PUT /users.1.json
  def update

    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to action: "index" }
        format.json { head :no_content }
      else
        format.html { render action: "index" }
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
          # Create default Permissions
          PermissionsSubcategory.all.each do |sub|
            a = PermissionsUser.new(  :permissions_subcategory_id => sub.id,
                                      :user_id => @new_user.id,
                                      :p_create => false,
                                      :p_view => false,
                                      :p_modify => false,
                                      :p_delete => false,
                                      :p_close => false,
                                      :p_accounts => false,
                                      :p_pdf => false,
                                      :p_exel => false )
            a.save
          end

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

  def permissions
    @user = User.find(params[:id])
    @permissionsCategory = PermissionsCategory.all
    @permissionsUser = PermissionsUser.where('user_id = ?', @user.id)
  end

  def search_user
    @users = User.search_users(params[:username], params[:name], params[:page], 5)
    respond_with @users
  end

  def save_permissions
    
    data = params['permissions_user']
    user_id = params['user_id']

    msg = { :status => "ok", :message => "Success!", :notice => 'Actualizado exitosamente' }

    respond_to do |format|

      if User.save_permissions_user(data, user_id)
        format.json  { render :json => msg }
        # format.json {  redirect_to users_path, status: 201, notice: 'Actualizado exitosamente' }
      else
        format.json {  redirect_to users_path, status: 500, notice: 'Ocurrio un error Actualizado', head: ok, url: users_path }
      end

    end
  end

  def get_permissions_user
    
    @data = User.get_permissions(params[:id])
    render :json => { :data => @data }
  end

  def test
    puts 'TEST UPDATE :D'
  end

end

