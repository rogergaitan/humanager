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

end
