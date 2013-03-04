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

	def firebird_encoding(element)
		element.encode('UTF-8', 'iso-8859-1')
	end

  def link_to_add_fields(name, f, association, option_class = "")
    new_object = f.object.send(association).klass.new
    id = new_object.object_id.to_s
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("forms/" + association.to_s.singularize + "_form", f: builder)
    end
    #WE'LL USE CSS CLASSES AS PARAMETER NOT BY DEFAULT TO KEEP THIS MORE CLEANER
    link_to(name, '#', class: " "+option_class, data: {id: id, fields: fields.gsub("\n", "")})
  end

  def default_company
  	@company ||= Company.find_by_default(true)
    @company ? session[:company] = @company.surname : session[:company] = "Seleccionar empresa"  
  	@company ? session[:company_id] = @company.id : session[:company_id] = 0
    @company ? @company.surname : ""
  end

  def translate_enum(enum)
    I18n.t(enum).map { |key, value| [ value, key ] }
  end
end

