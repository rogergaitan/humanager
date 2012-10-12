# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

	def firebird_encoding(element)
		element.encode('UTF-8', 'iso-8859-1')
	end
end
