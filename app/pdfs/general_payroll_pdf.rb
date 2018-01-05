class GeneralPayrollPDF < Prawn::Document
  include ActionView::Helpers::NumberHelper
  
  def initialize(data, payroll_ids, company_id)
    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
    @data = data
    @end_date = nil
    @start_date = nil
    @name_payrolls = nil
    @company = Company.find_by_code(company_id)
    get_dates(payroll_ids)
    start()
  end

  private
  
  def start
    header_page()
    create_table(@data)
    print_date()
  end
  
  def header_page
    repeat(:all) do
    
      font_size(7) do
        bounding_box([550, 500], :width => 250, :height => 50) do
          text "Reporte General de Planilla", :align => :left, :style => :bold, character_spacing: 1
          string = "Planilla #{@name_payrolls} del #{@start_date} al #{@end_date}"
          text string, :align => :left, :style => :bold
        end
        
        bounding_box([0, 500], :width => 350, :height => 50) do
          text "#{@company.label_reports_1}", :align => :left, :style => :bold, :character_spacing => 1
          text "#{@company.label_reports_2}", :align => :left, :style => :bold, :character_spacing => 1
          text "#{@company.label_reports_3}", :align => :left, :style =>  :bold, :character_spacing => 1
        end
      end
    end
  end
  
  def create_table(data)
    header = get_header(data[0])
    rows = []
    
    data.each_with_index do |item, index|
      row = []
      style = :normal
      align = :left
      if index == data.size-1
        style = :bold 
        align = :right
      end
    
      item.each do |key, value|
        if key == "Nombre Empleado"
          row << {:content => "#{value}", :font_style => style, :width => 160, :size => 8, :align => align}
        elsif key == "Otros Pagos"
          nested_rows(value, header[2], row, 2)
        elsif key == "Deducciones"
          nested_rows(value, header[3], row, 2)
        elsif key == "Total Otros Pagos" or key == "Total Deducciones"
          nested_totals(value, row)
        else
          if value == 0
            row << na_value()
          else
            row << amount_value(value)
          end
        end
      end
      rows << row
    end # End data
    
    page_count = 0
    total_pages = rows.each_slice(20).count
    
   #show table only when employees exists on rows
    if rows.count - 1 > 0
      rows.each_slice(20) do |rows|
        page_count += 1
        start_new_page if page_count > 1
        
        print_date()
    
        if page_count == total_pages
          employee_signature(rows.count - 1)
        else
          employee_signature(rows.count)
        end
        
        bounding_box([0, 440], :width => 600) do
          table(
            [header] + rows.each do |row|
              row
            end,
              :header => true,
              :cell_style => {:valign => :center},
              :position => :left
            )
        end
      end
    else
      print_date()
    end
  end
  
  def get_header(data)
    header = []    
    data.each do |key, value|
      if key == "Otros Pagos"
        header << [[set_header(key, 2, 18)]]
      elsif key == "Deducciones"
        header << [[set_header(key, 3, 18)]]
      else
        header << set_header(key)
      end
    end
    header
  end
  
  def set_header(key, colspan = 1, height = 6, size = 8)
    {:content => "#{key}", :font_style => :bold, :align => :center, 
      :colspan => colspan, :height => height, :size => size}
  end
  
  def print_date
    bounding_box([0, 15], :width => 150) do
      text "#{DateTime.now.strftime("Impreso el %d/%m/%Y a las %I:%M %p")}", :size => 7
    end
  end
  
  def employee_signature(rows)
    bounding_box([635, 420], :width => 120) do
      text "Firma del Empleado", :align => :center, :size => 8, :style => :bold
      move_down(28)
      
      rows.times do
        stroke_horizontal_rule
        move_down(20)
      end
    end
  end
  
  def number_to_format(number, currency_symbol = "")
    number_to_currency(number, :precision => 2, :format => "%u%n", :unit => currency_symbol)
  end
  
  def na_value
    {:content => "N/A", :align => :center, :size => 7, :width => 60, :height => 20 }
  end
  
  def amount_value(value)
    {:content => "#{number_to_format(value, @currency_symbol)}", :align => :right, :size => 7, 
      :width => 60, :height => 20, :valign => :center }
  end
  
  def header_key(value)
    value = "N/A" if value.start_with? "N/A"
    {:content => "#{value}", :size => 6, :width => 60, :height => 20, :align => :center}
  end
  
  def nested_rows(items, header, row, header_rows)
    subheader_row = []
    subvalues_row = []
    
    items.each do |key, value|
      subheader_row << header_key(key) unless header.count == header_rows
      subvalues_row << amount_value(value)
    end
    
    header << subheader_row unless header.count == header_rows
    row << [subvalues_row]
  end
  
  def nested_totals(items, row)
    subvalues_row = []
    
    if items.count > 0
      items.each do |key, value|
        subvalues_row << amount_value(value)
      end
    else
      subvalues_row << amount_value(0)
    end

    row << [subvalues_row]
  end
  
  def get_dates(payroll_ids)
    Payroll.includes(:currency, :payroll_log).where(:id => payroll_ids).each do |p|
      
      @name_payrolls = "#{p.payroll_type.description}"
      @currency_symbol = p.currency.symbol
      
      if(@start_date.nil? and @end_date.nil?)
        @start_date = p.start_date
        @end_date = p.end_date
      else
        if(@start_date > p.start_date)
          @start_date = p.start_date
        end
        
        if(@end_date < p.end_date)
          @end_date = p.end_date
        end
      end
    end
    
    if payroll_ids.count > 1
      @name_payrolls = 'Varios'
    end
  end
  
end
