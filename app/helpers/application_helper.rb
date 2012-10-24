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
	def link_to_add_fields(name, f, association)
    	new_object = f.object.send(association).klass.new
    	id = new_object.object_id
    	fields = f.fields_for(association, new_object, child_index: id) do |builder|
      		render("forms/" + association.to_s.singularize + "_form", f: builder)
    	end
    link_to(name, '#', class: "add_fields btn btn-mini btn-success", data: {id: id, fields: fields.gsub("\n", "")})
  end	
end
