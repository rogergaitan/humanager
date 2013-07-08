class GeneralPayrollPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

  def initialize(data)
    
    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
    @data = data
    start
  end

  def start

    @data.each do |payroll_id, d|
      header_page(payroll_id)
      create_table(d)
      start_new_page()
    end # End each @data
  end

  def header_page(payroll_id)

    p = Payroll.find(payroll_id)

    font_size(10) do
      text_box "Agro Vicces S.A.", :align => :left, style: :bold, character_spacing: 1
      text_box "Reporte General de Planilla", :align => :right, style: :bold, character_spacing: 1
    end
    move_down 20
    string = "Planilla #{p.payroll_type.description} del #{p.start_date} al #{p.end_date}"
    text string, :align => :center, style: :bold, character_spacing: 1.5
    move_down 10
  end

  def create_table(data)

    header = get_header(data[0])
    rows = []

    data.each do |d|
      row = []
      d.each do |key, value|
        row << "#{value}"
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

end