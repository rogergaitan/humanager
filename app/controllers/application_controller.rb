class ApplicationController < ActionController::Base

	#Allows user to keep session on
	before_filter :authenticate_user!

	respond_to :json, :html

	protect_from_forgery
  	rescue_from CanCan::AccessDenied do |exception|
	  flash[:error] = "Acceso Denegado."
	  redirect_to root_url
	end

	def firebird_encoding(element)
		element.encode('UTF-8', 'iso-8859-1')
	end

	def searchPermissions(user, id)
		user.permissions_user.find_by_permissions_subcategory_id(list['Planillas'])
	end

	def to_bool(string)
		return true if string == true || string =~ (/(true|t|yes|y|1)$/i)
		return false if string == false || string.blank? || string =~ (/(false|f|no|n|0)$/i)
		raise ArgumentError.new("invalid value for Boolean: \"#{string}\"")
	end

	def session_edit_validation(model, reference_id)

		user_id = current_user.id
		ip_address = request.remote_ip

		unless SessionValidation.validate_session(model, reference_id, user_id, ip_address)
			flash[:warning] = t('.notice.can_not_edit')
			redirect_to url_for(:controller => model.model_name.plural, :action => :index)
		end
	end

	def responses(response, status = 200, location = nil)
		render json: response, status: status
	end

	# Param <tt>object</tt> to return a paginated response by ajax
	def process_response(object)
		resp = {
			current_page: object.current_page,
			total_entries: object.count(),
			entries: object
		} unless @object
	end
	
	def after_sign_in_path_for(resource)		

		@sync_status = firebird_sync_from_sign
		#require 'pry'; binding.pry
		super    
	end

	def firebird_sync_from_sign
		@last_sync = SyncLog.last
		today = Time.now
		users = User.all
		first_sign = true
		users.each do |user|
			last_sign_in_at = user[:last_sign_in_at] ? user[:last_sign_in_at].to_date : 0
			if last_sign_in_at === today.to_date
				first_sign = false
				break
			end
		end

		if first_sign === true
			firebird_sync = firebird_sync_process
			return firebird_sync
		end
	end

	# Sync all tables
	def firebird_sync_process
		@sync = {}
		@sync[:companies] = companiesfb
		@sync[:tasks] = tasksfb
		@sync[:users] = usersfb
		@sync[:employees] = Employee.sync_fb
		@sync[:account] = accountfb
    @sync[:payment_type] = PaymentType.sync_fb

		log_sync

		return @sync
	end

	#save sync log
	def log_sync
		new_log = SyncLog.new( :user_id => current_user.id, 
								:last_sync => Time.now )

		new_log.save

	end

	# Sync companies
  	def companiesfb
	    @empmaestcc = Empmaestcc.includes(:empagropecuaria).find(:all, :select =>['iemp', 'ncc'], :conditions => ['icc = ?', ''])
	    @c = 0; @ca = 0
	    @companies = []
	    @companies_fb = {}
        
	    @empmaestcc.each do |cfb|
          empagropecuaria_params = { :label_reports_1 => cfb.empagropecuaria.srotulorpt1,
                                                           :label_reports_2 => cfb.empagropecuaria.srotulorpt2,
                                                           :label_reports_3 => cfb.empagropecuaria.srotulorpt3,
                                                           :page_footer => cfb.empagropecuaria.sinfopiepagina
                                                        }  
            
	      if Company.where('code = ?', cfb.iemp).empty?
            
            new_company_params = {:code => cfb.iemp, :name => "#{cfb.ncc}"}.merge empagropecuaria_params
            
	        @new_company = Company.new(new_company_params)

	        if @new_company.save
	          @companies << @new_company
	          @c += 1
	        else
	          @new_company.errors.each do |error|
	            Rails.logger.error "Error Creating Company: #{cfb.ncc}, Description: #{error}"
	          end
	        end
	      else
	        # UPDATE
	        @update_company = Company.find_by_code(cfb.iemp)
	        params[:company] = { :name => "#{cfb.ncc}"}.merge empagropecuaria_params

	        if @update_company.update_attributes(params[:company])
	          @ca += 1
	        end
	      end
	    end
		@companies_fb[:companies] = @companies
		@companies_fb[:notice] = ["#{t('helpers.titles.tasksfb')}: #{@c} #{t('helpers.titles.tasksfb_update')}: #{@ca}"]


	    return @companies_fb
  	end
	
	# Sync tasks
  	def tasksfb
	    labmaests = Labmaest.includes(:actividad).find( :all, :select => ['iactividad', 'ilabor', 'nlabor', 'nunidad'] )

	    c = 0
	    ca = 0
	    @tasks_fb = {}

	    labmaests.each do |task|
	      theTask = Task.where("itask = ?", task.ilabor).first
	      if theTask.nil?
	        new_task = Task.new(:iactivity => task.iactividad, 
	          :itask => task.ilabor, 
	          :ntask => firebird_encoding(task.nlabor), 
            :nunidad => firebird_encoding(task.nunidad),
            :nactivity=> firebird_encoding(task.actividad.try(:nactividad))
	        )

	        if new_task.save
	          c +=  1
	        else
	          new_task.er.each do |error|
	            Rails.logger.error "Error Creating task: #{task.ilabor}, Description: #{error}"
	          end
	        end
	      else
	        params[:task] = { :iactivity => task.iactividad, :ntask => firebird_encoding(task.nlabor),
                                           :nunidad => firebird_encoding(task.nunidad), 
                                           :nactivity => firebird_encoding(task.actividad.try(:nactividad)) }

	        if theTask.update_attributes(params[:task])
	          ca += 1
	        end
	      end
	    end
    	@tasks_fb[:notice] =  ["#{t('helpers.titles.tasksfb')}: #{c} #{t('helpers.titles.tasksfb_update')}: #{ca}"]

    	return @tasks_fb
 	end
	
	# Sync users
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

	    return @users_fb
  	end

  	def randow_string
	    value = ""; 8.times{ value << (65 + rand(25)).chr }
	    return value
	end

	# Sync ledger accounts
  	def accountfb
	    cntpuc = Cntpuc.where("bvisible = ?", 'T').find(:all, :select => ['icuenta', 'ncuenta', 'ipadre'])

	    c = 0; ca = 0
	    @accounts_fb = {}

	    cntpuc.each do |account|
	      if LedgerAccount.where("iaccount = ?", account.icuenta).empty?
	        new_account = LedgerAccount.new(:iaccount => account.icuenta, :naccount => firebird_encoding(account.ncuenta),
	          :ifather => account.ipadre)
	        if new_account.save
	          c += 1
	        else
	          @new_task.er.each do |error|
	            Rails.logger.error "Error Creating account: #{account.icuenta}, 
	                              Description: #{error}"
	          end
	        end
	      else
	        # UPDATE
	        update_cntpuc = LedgerAccount.find_by_iaccount(account.icuenta)
	        params[:ledgerAccount] = { :naccount => firebird_encoding(account.ncuenta), :ifather => account.ipadre }
	        if update_cntpuc.update_attributes(params[:ledgerAccount])
	          ca += 1
	        end
	      end 
	      @accounts_fb[:notice] = ["#{t('helpers.titles.tasksfb').capitalize}: #{c} #{t('helpers.titles.tasksfb_update')}: #{ca}"]
	    end 

	    return @accounts_fb
  	end 

end
