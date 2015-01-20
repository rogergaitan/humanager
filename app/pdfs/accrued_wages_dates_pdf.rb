class AccruedWagesDatesPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

	def initialize(data, company_id, start_date, end_date)

	    super(top_margin: 5, :page_size => "A4")
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
			#bounding_box [700, bounds.bottom + 15], :width  => bounds.width do
			bounding_box [450, bounds.bottom + 15], :width  => bounds.width do
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
		header << { :content => "# Empleado", :font_style => :bold, :align => :left }
		header << { :content => "Identificacion", :font_style => :bold, :align => :left }
		header << { :content => "Nombre", :font_style => :bold, :align => :center }
		header << { :content => "Total Devengado", :font_style => :bold, :align => :center }

		rows = []
		total = 0

		data.each do |d|
			row = []
			row << d['number_employee']
			row << d['entityid']
			row << d['full_name']
			row << { :content => number_to_format(d['total']), :align => :right }
			total += d['total'].to_f
			rows << row
		end # End data

		row = []
		row << { :content => "Total:", :align => :right, :colspan => 3, :font_style => :bold }
		row << { :content => "#{number_to_format(total)}", :align => :right, :font_style => :bold }
		rows << row

		table(
		[header] +
		rows.map do |row| row end,
		:cell_style => { :size => 10 }
		)
	end

	def number_to_format(number)
		number_to_currency(number, :precision => 2, :format => "%u%n", :unit => "")
	end

end
