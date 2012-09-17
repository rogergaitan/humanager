# Application Helper 
module ApplicationHelper
	# This method help us to manage the title of the page
	def title
		base_title = "Reasa"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end	
end
