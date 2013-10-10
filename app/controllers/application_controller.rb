class ApplicationController < ActionController::Base

	#Allows user to keep session on
	before_filter :authenticate_user!

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

end
