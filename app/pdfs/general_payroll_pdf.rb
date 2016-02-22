class GeneralPayrollPDF < Prawn::Document
include ActionView::Helpers::NumberHelper
  
  # t_d = total deductions
  # t_o = total other payments
  def initialize(data, payroll_ids, company_id, t_d, t_o)
    super(top_margin: 5, :page_size => "A4", :page_layout => :landscape)
    @data = data
    @end_date = nil
    @start_date = nil
    @name_payrolls = nil
    @company = Company.find(company_id)
    @t_d = t_d
    @t_o = t_o
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
      # string = "Planilla #{@payroll.payroll_type.description} del #{@payroll.start_date} al #{@payroll.end_date}"
      # text_box string, :align => :right, :at => [0, y - 50]
      string = "Planilla #{@name_payrolls} del #{@start_date} al #{@end_date}"
      text_box string, :align => :right, :at => [0, y - 50]
    end

    text "#{@company.label_reports_1}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_2}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_3}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    

    move_down 20
  end

  def create_table(data)

    header = get_header(data[0])
    rows = []

    data.each_with_index do |d, i|
      row = []

      a = :normal
      a = :bold if i == data.size-1

      d.each do |key, value|

        if( key == 'Nombre Empleado')
          row << {:content => "#{value}", :font_style => a}
        else
          if value == 0
            row << { :content => "N/A", :align => :right, :font_style => a, :width => 60 }
          else
            row << { :content => "#{number_to_format(value)}", :align => :right, :font_style => a, :width => 60 }
          end
        end
      end
      rows << row
    end # End data
    main = [
      {:content => "", :colspan => 2, :borders => [:bottom]},
      {:content => "Deducciones", :colspan => @t_d+1, :font_style => :bold, :align => :center },
      {:content => "Otros Pagos", :colspan => @t_o+1, :font_style => :bold, :align => :center },
      {:content => "", :borders => [:bottom]}
    ]

    table(
      [main,header] +
      rows.map do |row| row end,
      :cell_style => { :size => 8 }
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