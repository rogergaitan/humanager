class GeneralPayrollPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

  def initialize(data, payroll_ids, company_id)
    
    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
    @data = data
    @end_date = nil
    @start_date = nil
    @name_payrolls = nil
    @company = Company.find(company_id)
    get_dates(payroll_ids)
    start
  end

  def start
    header_page()
    create_table(@data)
  end

  def header_page()

    font_size(10) do
      text_box "Reporte General de Planilla", :align => :right, style: :bold, character_spacing: 1
    end

    text "#{@company.label_reports_1}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_2}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_3}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    

    move_down 20
    string = "Planilla #{@name_payrolls} del #{@start_date} al #{@end_date}"
    
    text string, :align => :center, style: :bold, character_spacing: 1.5
    move_down 10
  end

  def create_table(data)

    header = get_header(data[0])
    rows = []

    data.each do |d|
      row = []
      d.each do |key, value|
        if( key == 'Nombre Empleado')
          row << "#{value}"
        else
          if value == 0
            row << { :content => "--", :align => :right }
          else
            row << { :content => "#{number_to_format(value)}", :align => :right }
          end
        end
      end
      rows << row
    end # End data

    table(
      [header] +
      rows.map do |row| row end,
      :cell_style => { :size => 10 }
    )
  end

  def get_header(data)
    header = []    
    data.each do |key, value|
      header << { :content => "#{key}", :font_style => :bold, :align => :center }
    end
    header
  end

  def number_to_format(number)
    number_to_currency(number, :precision => 2, :format => "%u%n", :unit => "")
  end

  def get_dates(payroll_ids)

    Payroll.where( :id => payroll_ids ).each do |p|

      @name_payrolls = "#{p.payroll_type.description}"
      
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