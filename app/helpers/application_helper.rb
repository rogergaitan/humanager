# -*- encoding : utf-8 -*-
module ApplicationHelper
	def title
		base_title = "Reasa"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
# Encode the data from the firebird database
	def firebird_encoding(element)
		element.encode('UTF-8', 'iso-8859-1')
	end
end