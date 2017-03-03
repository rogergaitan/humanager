class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:permissions]
  load_and_authorize_resource
  respond_to :html, :json, :js
  skip_before_filter :verify_authenticity_token, :only => [:update, :save_permissions, :change_company]

  before_filter :only => [:edit, :update] do |controller|
    session_edit_validation(User, params[:id])
  end

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

  def usersfb
    usersfb = Abausuario.find(:all, :select => ['nusr', 'snombre', 'sapellido', 'semail'])
    c = 0; ca = 0
    @users_fb = {}

    usersfb.each do |ufb|
      
      if User.where("username = ?", ufb.nusr).empty?

        numer = randow_string
        new_user = User.new( :username => "#{ufb.nusr}",
                              :name => "#{ufb.snombre} #{ufb.sapellido}", 
                              :email => "#{ufb.semail}", 
                              :password => numer, 
                              :password_confirmation => numer )

        if new_user.save
          # Create default Permissions
          PermissionsSubcategory.all.each do |sub|
            a = PermissionsUser.new(  :permissions_subcategory_id => sub.id,
                                      :user_id => new_user.id,
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

          c += 1
        else
          new_user.errors.each do |error|
            Rails.logger.error "Error Creating User: #{ufb.nusr}, Description: #{error}"
          end
        end
      else

        update_user = User.find_by_username(ufb.nusr)
        params[:user] = { :name => "#{ufb.snombre} #{ufb.sapellido}", :email => "#{ufb.semail}" }

        if update_user.update_attributes(params[:user])
          ca += 1
        end
        
      end # End if
    end # End each usersfb

    @users_fb[:notice] = ["#{t('helpers.titles.tasksfb')}: #{c} #{t('helpers.titles.tasksfb_update')}: #{ca}"]
    respond_to do |format|
      format.json { render json: @users_fb }
    end
  end

  def randow_string
    value = ""; 8.times{ value << (65 + rand(25)).chr }
    return value
  end

  # PUT /PERMISSIONS /permissions/1
  def permissions
    # authorize! :permissions_users, params[:id]
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
    respond_to do |format|

      if User.save_permissions_user(data, user_id)
        format.json { redirect_to users_path, :status => 200, :message => "Success!", :notice => 'Actualizado exitosamente' }
      else
        format.json {  redirect_to users_path, status: 500, notice: 'Ocurrio un error Actualizado', head: ok, url: users_path }
      end

    end
  end

  def get_permissions_user
    @data = User.get_permissions(params[:id])
    render :json => { :data => @data }
  end

  def change_company
    user = current_user
    user.company_id = params['company_id']
    
    respond_to do |format|
      if user.save
        format.json { render json: { 'status' => true }, status: :ok }
      else
        format.json { render json: { 'status' => false, 'errors' => user.errors }, status: :unprocessable_entity }
      end
    end
  end

  def test
    puts 'TEST UPDATE'
  end

end

