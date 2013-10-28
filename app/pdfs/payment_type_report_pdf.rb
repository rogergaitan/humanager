class PaymentTypeReportPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

  def initialize(data, order, payroll_ids)
    
    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
    @data = data
    @end_date = nil
    @start_date = nil
    @name_payrolls = nil
    get_dates(payroll_ids)
    big_total
    @order = order
    
    @order_by = 'Agrupado por '
    if order == 'employee'; @order_by += 'Empleados' end
    if order == 'task'; @order_by += 'Tareas' end
    if order == 'centro_costo'; @order_by += 'Centro de Costo' end
    if order == 'no_order'; @order_by = 'Sin Agrupar' end
      
    repeat(:all, :dynamic => true) do
      
      # HEADER
      bounding_box [bounds.left, bounds.top], :width  => bounds.width do
        header_page
      end

      # FOOTER
      bounding_box [bounds.left, bounds.bottom + 15], :width  => bounds.width do
        move_down(5)
        time = Time.new
        text "Impreso el: #{time.day}/#{time.month}/#{time.year} #{time.hour}:#{time.min}:#{time.sec}", :size => 10
      end

      bounding_box [700, bounds.bottom + 15], :width  => bounds.width do
        move_down(5)
        text "Pagina #{page_number} de #{page_count}", :size => 10
      end
    end

    bounding_box([bounds.left, bounds.top - 90], :width  => bounds.width, :height => bounds.height - 100) do
      start
    end
  end

  def start
    
    header = get_headers()
    dt = []

    @data.each do |d|

      if @order == 'employee' || @order == 'task'
        move_down 20
        text "#{d['nombre']}", character_spacing: 1
        move_down 10
        get_tables(header, d['info'])
      end
      
      if @order == 'centro_costo'
        move_down 20
        text "#{d['nombre']}", character_spacing: 1
        move_down 10
        get_tables(header, d['info'])
      end
      
      if @order == 'no_order'
        d.each do |e|
          dt << e
        end
      end

    end # End each @data
    
    if @order == 'no_order'
      get_tables(header, dt)
    end

    move_down 20
    stroke_horizontal_rule
    move_down 20
    set_table_total(header)
  end

  def header_page

    font_size(10) do
      text_box "Agro Vicces S.A.", :align => :left, style: :bold, character_spacing: 1
      text_box "Reporte de Labores Por Tipo de Pago", :align => :center, style: :bold, character_spacing: 1
    end
    move_down 20
    string = "#{@order_by}"
    text string, :align => :center, style: :bold, character_spacing: 1.5

    move_down 10
    string = "Planilla #{@name_payrolls} del #{@start_date} al #{@end_date}"
    
    text string, :align => :center, style: :bold, character_spacing: 1.5
    move_down 10
  end

  def get_headers()

    header_list = []
    header = []

    if @order == 'employee'
      header_list << 'Labor'
      header_list << 'Centro de Costo'
    end

    if @order == 'task'
      header_list << 'Nombre'
      header_list << 'Centro de Costo'
    end

    if @order == 'centro_costo'
      header_list << 'Nombre'
      header_list << 'Labor'
    end

    if @order == 'no_order'
      header_list << 'Nombre'
      header_list << 'Tarea'
      header_list << 'Centro de Costo'
    end

    header_list << 'Tot Uni Ord'
    header_list << 'Val tot Ord'
    header_list << 'Tot Uni Ext'
    header_list << 'Val tot Ext'
    header_list << 'Tot Uni Dob'
    header_list << 'Val tot Dob'
    header_list << 'Gran Total'    
    
    header_list.each do |title|
      header << { :content => title, :colspan => 2, :font_style => :bold }
    end
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

  def get_tables(header, info)
    
    row = []; rows = []; count = 0

    info.each do |a|
      count += 1
      
      if @order == 'employee' || @order == 'task'
        row << a['nombre'] # Labor
        row << a['cc']
      end

      if @order == 'centro_costo'
        row << a['nombre']
        row << a['task']
      end

      if @order == 'no_order'
        row << a['nombre']
        row << a['tarea']
        row << a['cc']
      end

      row << "#{number_to_format(a['total_unid_ord'])}"
      row << "#{number_to_format(a['valor_total_ord'])}"
      row << "#{number_to_format(a['total_unid_extra'])}"
      row << "#{number_to_format(a['valor_total_extra'])}"
      row << "#{number_to_format(a['total_unid_doble'])}"
      row << "#{number_to_format(a['valor_total_doble'])}"
      row << "#{number_to_format(a['total'])}"
      
      if info.count == count
        @total['total_unid_ord'] += a['total_unid_ord']
        @total['valor_total_ord'] += a['valor_total_ord']
        @total['total_unid_extra'] += a['total_unid_extra']
        @total['valor_total_extra'] += a['valor_total_extra']
        @total['total_unid_doble'] += a['total_unid_doble']
        @total['valor_total_doble'] += a['valor_total_doble']
        @total['total'] += a['total']
      end

      rows << row
      row = []
    end
    get_table(header, rows)
  end

  def get_table(header, rows)

    table(
      [header] +
      rows.map do |row| row end,
      :cell_style => { :align => :right, :size => 8, :height => 19 },
      :position => :right
    )
  end

  def big_total
    @total = {
            'nombre' => 'Gran Total',
            'total_unid_ord' => 0,
            'valor_total_ord' => 0,
            'total_unid_extra' => 0,
            'valor_total_extra' => 0,
            'total_unid_doble' => 0,
            'valor_total_doble' => 0,
            'total' => 0
          }
  end

  def set_table_total(header)

    row = []; rows = []

    row << @total['nombre']
    row << "#{number_to_format(@total['total_unid_ord'])}"
    row << "#{number_to_format(@total['valor_total_ord'])}"
    row << "#{number_to_format(@total['total_unid_extra'])}"
    row << "#{number_to_format(@total['valor_total_extra'])}"
    row << "#{number_to_format(@total['total_unid_doble'])}"
    row << "#{number_to_format(@total['valor_total_doble'])}"
    row << "#{number_to_format(@total['total'])}"
    rows << row
    row = []

    table(
      [['','Tot Uni Ord','Val tot Ord','Tot Uni Ext','Val tot Ext','Tot Uni Dob','Val tot Dob', 'Gran Total']] +
      rows.map do |row| row end,
      :cell_style => { :align => :right, :size => 8, :height => 19 },
      :position => :right
    )
  end

end