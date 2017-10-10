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

		link_to name, tabindex: '10', class: "add_fields btn btn-primary btn-xs icon-plus" + fieldClass, 
			id: association, data: {id: id, fields: fields.gsub("\n", "")} do
			content_tag(:i, "", :class => 'fa fa-plus')
		end
	end

  	def translate_enum(enum)
    	I18n.t(enum).map { |key, value| [ value, key ] }
  	end

	# change the default link renderer for will_paginate
	def will_paginate(collection = nil, options = {})
		options[:renderer] ||= WillPaginationHelper::LinkRenderer
		options[:class] ||= 'tab-pane active'
		options[:inner_window] ||= 2
		options[:outer_window] ||= 1
		super *[collection, options].compact
	end

	def all_companies_selector(company_id)
		@companies = Company.all
		collection_select(:user, :company_id, @companies, :code, :name,
		    options = { :prompt => true, :selected => company_id }, 
		    html_options = { :class => 'form-control', :style => 'margin-top: 10px', 
		    	:data => { :url => change_company_users_path }
		    }
		)
	end

	def build_query(data)
		query = ""
		if data
			data.each_with_index do |q, i|
				if i < data.length - 1
					query += q + " AND "
				else
					query += q
				end
			end
		end
		query
	end
  
  #used by models with state to show if active
  def state_helper(state)
    if state == :active
      "Si"
    else
      "No"
    end
  end
  
  #used by models with calculation and individual attributes
  #to show individual, percent or currency value
  def value_helper(model, value_method, currency)
    if model.individual
      "Individual"
    elsif model.calculation_type == :percentage
      "#{model.send(value_method)}%"
    elsif model.calculation_type == :fixed
     number_to_currency model.send(value_method), unit: model.send(currency).try(:symbol), delimeter: ""
    end 
  end

end
