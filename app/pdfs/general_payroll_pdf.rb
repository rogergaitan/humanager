class GeneralPayrollPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

  def initialize(data, payroll_ids)
    
    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
    @data = data
    @end_date = nil
    @start_date = nil
    @name_payrolls = []
    get_dates(payroll_ids)
    start
  end

  def start
    header_page()
    create_table(@data)
  end

  def header_page()

    font_size(10) do
      text_box "Agro Vicces S.A.", :align => :left, style: :bold, character_spacing: 1
      text_box "Reporte General de Planilla", :align => :right, style: :bold, character_spacing: 1
    end

    move_down 20
    stringNames = ""

    if( @name_payrolls.count == 1 )
      string = "Planilla #{@name_payrolls[0]} del #{@start_date} al #{@end_date}"
    else
      string = "Reporte General de Planilla del #{@start_date} al #{@end_date}"
      stringNames = "Planillas"
      @name_payrolls.each do |name|
        stringNames += " #{name}, "
      end
    end
    stringNames = stringNames.chomp(",")
    text string, :align => :center, style: :bold, character_spacing: 1.5
    text stringNames, :align => :center, style: :bold, character_spacing: 1.5
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
          row << "#{number_to_format(value)}"
        end
      end
      rows << row
    end # End data

    table(
      [header] +
      rows.map do |row| row end
    )
  end

  def get_header(data)
    header = []    
    data.each do |key, value|
      header << {:content => "#{key}", :font_style => :bold}
    end
    header
  end

  def number_to_format(number)
    number_to_currency(number, :precision => 2, :format => "%u%n", :unit => "")
  end

  def get_dates(payroll_ids)

    Payroll.where( :id => payroll_ids ).each do |p|

      @name_payrolls << "#{p.payroll_type.description}"
      
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
    @name_payrolls = @name_payrolls.uniq
  end

end