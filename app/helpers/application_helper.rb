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

# Encode the data from the firebird database
	def firebird_encoding(element)
		element.encode('UTF-8', 'iso-8859-1')
	end
  
  def link_to_add_fields(name, f, association, fieldClass)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("forms/" + association.to_s.singularize + "_form", f: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-mini btn-success " + fieldClass, id: association, data: {id: id, fields: fields.gsub("\n", "")})
  end

end

