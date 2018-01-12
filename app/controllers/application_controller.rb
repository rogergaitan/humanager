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

    return firebird_sync_process if first_sign
  end

	# Sync all tables
  def firebird_sync_process
    @sync = {}
    @sync[:companies] = Company.sync_fb
    @sync[:tasks] = Task.sync_fb
    @sync[:users] = User.sync_fb
    @sync[:employees] = Employee.sync_fb
    @sync[:account] = LedgerAccount.sync_fb
    @sync[:payment_type] = PaymentType.sync_fb
    @sync[:creditors] = Creditor.sync_fb
    @sync[:supports] = Support.sync_fb
    @sync[:cost_centers] = CostsCenter.sync_fb
    log_sync
    return @sync
  end

  # Save sync log
  def log_sync
    new_log = SyncLog.new( :user_id => current_user.id, :last_sync => Time.now )
    new_log.save
  end

end
