class PaymentTypeReportPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

  def initialize(data, order, payroll_ids)
    
    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
    
    @data = data
    @end_date = nil
    @start_date = nil
    @name_payrolls = []
    get_dates(payroll_ids)
    
    if order == 'employee'
      @order = 'Empleado'
    else
      @order = 'Tarea'
    end

    repeat :all do
      bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        # header
        header_page
      end
    end

    bounding_box([bounds.left, bounds.top - 90], :width  => bounds.width, :height => bounds.height - 100) do                 
      start
    end

  end

  def start

    header = get_header()    

    @data.each do |d|

      move_down 20
      text "Agrupacion #{@order}: #{d['nombre']}", character_spacing: 1
      move_down 20
      get_table(header, d['info'])

    end # End each @data
  end

  def header_page

    font_size(10) do
      text_box "Agro Vicces S.A.", :align => :left, style: :bold, character_spacing: 1
      text_box "Reporte de Labores Por Tipo de Pago", :align => :center, style: :bold, character_spacing: 1
    end
    move_down 20
    string = "Agrupado por #{@order}s"
    text string, :align => :center, style: :bold, character_spacing: 1.5

    move_down 10
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

  def get_header()

    header = []
    header_list = [
        'Nombre', 
        'Total de Unid Ord',
        'Valor total Ord',
        'Total de Unid Ext',
        'Valor total Ext',
        'Total de Unid Dobles',
        'Valor total Doble',
        'Total'
    ]
    
    header_list.each do |title|
      header << {:content => title, :colspan => 2, :font_style => :bold}
    end
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

  def get_table(header, info)

    row = []
    rows = []

    nombre = 'TOTAL'
    total_unid_ord = 0
    valor_total_ord = 0
    total_unid_extra = 0
    valor_total_extra = 0
    total_unid_doble = 0
    valor_total_doble = 0
    total = 0

    info.each do |a|
      row << a['nombre']
      row << "#{number_to_format(a['total_unid_ord'])}"
      total_unid_ord += a['total_unid_ord']
      row << "#{number_to_format(a['valor_total_ord'])}"
      valor_total_ord += a['valor_total_ord']
      row << "#{number_to_format(a['total_unid_extra'])}"
      total_unid_extra += a['total_unid_extra']
      row << "#{number_to_format(a['valor_total_extra'])}"
      valor_total_extra += a['valor_total_extra']
      row << "#{number_to_format(a['total_unid_doble'])}"
      total_unid_doble += a['total_unid_doble']
      row << "#{number_to_format(a['valor_total_doble'])}"
      valor_total_doble += a['valor_total_doble']
      row << "#{number_to_format(a['total'])}"
      total += a['total']
      rows << row
      row = []
    end

    row << nombre
    row << "#{number_to_format(total_unid_ord)}"
    row << "#{number_to_format(valor_total_ord)}"
    row << "#{number_to_format(total_unid_extra)}"
    row << "#{number_to_format(valor_total_extra)}"
    row << "#{number_to_format(total_unid_doble)}"
    row << "#{number_to_format(valor_total_doble)}"
    row << "#{number_to_format(total)}"
    rows << row

    table(
      [header] +
      rows.map do |row| row end,
      :cell_style => { :align => :right, :size => 10, :height => 19 },
      :position => :right
    )
  end

end