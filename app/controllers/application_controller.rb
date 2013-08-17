class ApplicationController < ActionController::Base
  #Allows user to keep session on
  before_filter :authenticate_user!
  
  protect_from_forgery

	def firebird_encoding(element)
		element.encode('UTF-8', 'iso-8859-1')
	end

end
