class AccruedWagesDatesPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

	def initialize(data, company_id, start_date, end_date)

	    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
		@data = data
		@company = Company.find(company_id)
		@start_date = start_date
		@end_date = end_date
		start

		repeat(:all, :dynamic => true) do
			# FOOTER
			bounding_box [bounds.left, bounds.bottom + 15], :width  => bounds.width do
				move_down(5)
				time = Time.new
				text "Impreso el: #{time.day}/#{time.month}/#{time.year} #{time.hour}:#{time.min}:#{time.sec}", :size => 10
			end
			# PAGE NUMBER
			bounding_box [700, bounds.bottom + 15], :width  => bounds.width do
				move_down(5)
				text "Pagina #{page_number} de #{page_count}", :size => 10
			end
		end

	end

	def start
		header_page()
	    create_table(@data)
	end

	def header_page()

	    font_size(10) do
	      text_box "#{@company.name} Salarios Devengados Entre Fechas", :align => :right, style: :bold, character_spacing: 1
	    end
	    
	    move_down 20
	    string = "Desde #{@start_date} Hasta #{@end_date}"
	    
	    text string, :align => :center, style: :bold, character_spacing: 1.5
	    move_down 10
	end

	def create_table(data)

		header = []
		header << { :content => "Numero", :font_style => :bold, :align => :center }
		header << { :content => "ID", :font_style => :bold, :align => :center }
		header << { :content => "Nombre", :font_style => :bold, :align => :center }
		header << { :content => "Total Devengado", :font_style => :bold, :align => :center }

		rows = []
		total = 0

		data.each do |d|
			row = []
			d.each do |key, value|
				if( key == 'full_name')
					row << "#{value}"
				else
					if value == 0
						row << { :content => "--", :align => :right }
					else
						row << { :content => "#{(value)}", :align => :right }
						if(key=="total") 
							total += value.to_f 
						end
					end
				end
			end
			rows << row
		end # End data

		row = []
		row << { :content => "Total:", :align => :right, :colspan => 3 }
		row << { :content => "#{total}", :align => :right }
		rows << row

		table(
		[header] +
		rows.map do |row| row end,
		:cell_style => { :size => 10 }
		)
	end
end
