class ProofPayEmployeesPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

  def initialize(payroll, employees, msg, id_company)
    
    super(top_margin: 15, :left_margin => 20, :right_margin => 20)
    @payroll = payroll
    @employees = employees
    @total_devengado = 0
    @msg = msg
    @company = Company.find(id_company)
    start
  end

  def start

    list_payments_types = get_payments_types
    header = get_header()
    count = 0
    employee_ids = []
    c = 0
    cp = 0
    
    #@payroll_log_id = PayrollLog.includes(:payroll)
    #                            .where(payrolls:{company_id: @company.id, state: false }, payroll_logs: {payroll_id: 1})
    #                            .collect(&:id)
    @payroll_log_id = PayrollLog.select('id').where('payroll_id = ?', @payroll.id)
    @payroll_history_ids = PayrollHistory.select('id').where('payroll_log_id = ?', @payroll_log_id)
    if @payroll_history_ids.length == 0
      no_info
    else
      @payroll_history_ids.each do |i|
        e_id = PayrollEmployee.select('employee_id').where('payroll_history_id = ?', i)
        employee_ids[c] = e_id[0]['employee_id']
        c += 1
      end
      
      @employees.each do |employee_id|
        if employee_id.to_i == employee_ids.detect { |item| item == employee_id.to_i }
          cp += 1
        end  
      end

      @employees.each do |employee_id|
        
        if employee_id.to_i == employee_ids.detect { |item| item == employee_id.to_i }
          
          proof_pay_info
          move_down 5
          count += 1      
                   
          e = Employee.find(employee_id)
          co = @company
          employee =  "Empresa: #{co.name}
                       Empleado: #{e.entity.entityid} #{e.entity.surname} #{e.entity.name}"
          #company = "Empresa: #{co.name}"
          text employee, character_spacing: 1
          move_down 15
          #text Company, character_spacing: 1
          #move_down 15

          data_salary = get_data_salary(list_payments_types, employee_id)
          text "Detalle Salario Devengados", character_spacing: 1, :align => :center
          move_down 15

          data_deductions = get_data_deductions(employee_id)

          tRows = table_salary_earned(data_salary[0], data_salary[1], header, list_payments_types)

          if tRows.length > 1
            tables_salary(tRows, header, data_deductions, employee, company)
          else 
            tables_salary_center(tRows, header)
            table_deductions(data_deductions, true)
          end

          if count != cp #@employees.count
            start_new_page()
          end
        end
      end # End each employees
    end
  end

  def no_info
    text "No existen datos para mostrar"
  end

  def tables_salary(tRows, header, data_deductions, employee, company)

      c = 0; count = 0; lastTotalRows = 0
      print = false
      define_grid(:columns => 2, :rows => 1, :gutter => 5)

      tRows.each do |rows|
        count += 1
        if c > 1;  c = 0 end

        if c == 0
          grid([1,0],[0,0]).bounding_box do
            move_down 90
            table(
              header + 
              rows.map do |row| row end, 
                :cell_style => {:size => 8, :height => 19, :border_color => "FFFFFF" },
                :position => :left
            ) do
              row(0).borders = [:bottom]
              row(0).border_width = 2
              row(0).font_style = :bold
              row(0).border_color = "#000000"
            end
          end # end grid
        end # end if

        if c == 1
          lastTotalRows = rows.length
          grid([1,1],[0,0]).bounding_box do
            move_down 90
            table(
              header + 
              rows.map do |row| row end, 
                :cell_style => {:size => 8, :height => 19, :border_color => "FFFFFF" },
                :position => :right
            ) do
              row(0).borders = [:bottom]
              row(0).border_width = 2
              row(0).font_style = :bold
              row(0).border_color = "#000000"
            end

            if count == tRows.length
              if rows.length <= 19 # cantidad de rows kalfaro1
                move_down 10
                table_deductions(data_deductions, false)
                print = true
              end
            end
          end # end grid
          if count != tRows.length
            start_new_page()
            text employee, character_spacing: 1
            #text company, character_spacing: 1
          end
        end # end if

        c += 1
      end

      if c == 1
        grid([1,1],[0,0]).bounding_box do
            move_down 90
            table_deductions(data_deductions, false)
        end
      else
        if !print
          table_deductions(data_deductions, true)
        end
      end
  end

  def tables_salary_center(tRows, header)
    
    tRows.each do |rows|
      table(
        header + 
        rows.map do |row| row end, 
          :cell_style => {:size => 8, :height => 19, :border_color => "FFFFFF" },
          :position => :center
      ) do
        row(0).borders = [:bottom]
        row(0).border_width = 2
        row(0).font_style = :bold
        row(0).border_color = "#000000"
      end
    end
  end

  def proof_pay_info

    font_size(10) do
      text_box "Comprobante de Pago de Salario", :align => :right, style: :bold, character_spacing: 1
      string = "Planilla #{@payroll.payroll_type.description} del #{@payroll.start_date} al #{@payroll.end_date}"
      text_box string, :align => :right, :at => [0, y - 50]
    end

    text "#{@company.label_reports_1}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_2}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_3}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    move_down 20
  end

  def get_payments_types

    task_payment_type = [
      CONSTANTS[:PAYMENT][0]['name'].to_s, # Ordinario
      CONSTANTS[:PAYMENT][1]['name'].to_s, # Extra
      CONSTANTS[:PAYMENT][2]['name'].to_s  # Doble
    ]

    task_payment_type.uniq
  end

  def get_data_salary(list_payments_types, employee_id)

    result = []; data = []
    info_data = {}; info = {}
    
    totals = {
        'ordinario' => 0,
        'extra' => 0,
        'doble' => 0
    }
    
    payroll_history_ids = PayrollEmployee.where('employee_id = ?', employee_id).map(&:payroll_history_id)

    PayrollHistory.select("id, task_id, SUM(time_worked) as time_worked, payment_type_id, payroll_date, SUM(total) as total, task_unidad")
                  .where(:payroll_log_id => @payroll.id, :id => payroll_history_ids)
                  .group("payment_type_id, payroll_date").order("payroll_date").each do |p|

      obj = {}
      obj['labor'] = p.task.ntask
      obj['fecha'] = p.payroll_date

      if data.include?(obj)
        index = data.index(obj)

        if p.payment_type.payment_type.to_s == list_payments_types[0]
          result[index]['ordinario'] += p.time_worked.to_f
          totals['ordinario'] += p.total.to_f
        end
        
        if p.payment_type.payment_type.to_s == list_payments_types[1]
          result[index]['extra'] += p.time_worked.to_f
          totals['extra'] += p.total.to_f
        end

        if p.payment_type.payment_type.to_s == list_payments_types[2]
          result[index]['doble'] += p.time_worked.to_f
          totals['doble'] += p.total.to_f
        end
      else
        info_data['fecha'] = "#{p.payroll_date.strftime('%d')}/#{p.payroll_date.strftime('%m')}"
        info_data['labor'] = p.task.ntask
        info['fecha'] = info_data['fecha']
        info['labor'] = "#{p.task.ntask[0..20]}..."
        info['unidad'] = p.task_unidad
        info['ordinario'] = 0
        info['extra'] = 0
        info['doble'] = 0
        
        if p.payment_type.payment_type.to_s == list_payments_types[0]
          info['ordinario'] = p.time_worked.to_f
          totals['ordinario'] += p.total.to_f
        end
        
        if p.payment_type.payment_type.to_s == list_payments_types[1]
          info['extra'] = p.time_worked.to_f
          totals['extra'] += p.total.to_f
        end

        if p.payment_type.payment_type.to_s == list_payments_types[2]
          info['doble'] = p.time_worked.to_f
          totals['doble'] += p.total.to_f
        end

        result << info
        data << info_data
        info_data = {}
        info = {}
      end
    end # End each PayrollHistory
    
    [result, totals]
  end

  def get_header()

    header = [[ 
      {:content => "Fecha", :font_style => :bold },
      {:content => "Labor", :font_style => :bold },
      {:content => "Unid", :font_style => :bold },
      {:content => "Ord", :font_style => :bold },
      {:content => "Ext", :font_style => :bold },
      {:content => "Dob",  :font_style => :bold }
    ]]
  end

  def table_salary_earned(data, totals, header, lpt)
    
    tRows = []; rows = []; row = []
    total = 0; tOrdinario = 0; tExtra = 0; tDoble = 0; cRows = 0

    data.each do |obj|    
      cRows += 1

      obj.each do |a,b|
        if a.capitalize == lpt[0] || a.capitalize == lpt[1] || a.capitalize == lpt[2]
          row << { :content => "#{number_to_format(b)}", :align => :center }
        else
          if is_numeric("#{b}")
            row << { :content => "#{b}", :align => :right }
          else
            row << { :content => "#{b}", :align => :left }
          end
        end

        if a.capitalize == lpt[0].capitalize
          tOrdinario += b.to_f
        end

        if a.capitalize == lpt[1].capitalize
          tExtra += b.to_f
        end

        if a.capitalize == lpt[2].capitalize
          tDoble += b.to_f
        end
      end
      rows << row
      row = []      

      if cRows == 30
        tRows << rows
        rows = []
        cRows = 0
      end

    end # End each data

    # Cantidades Totales
    row << { :content => "Cantidades Totales", :colspan => 3, :align => :right, :font_style => :bold }
    row << { :content => "#{number_to_format(tOrdinario)}", :align => :right }
    row << { :content => "#{number_to_format(tExtra)}", :align => :right }
    row << { :content => "#{number_to_format(tDoble)}", :align => :right }
    rows << row
    row = []

    # Montos Totales
    row << { :content => "Montos Totales", :colspan => 3, :align => :right, :font_style => :bold }
    row << { :content => "#{number_to_format(totals['ordinario'])}", :align => :right }
    row << { :content => "#{number_to_format(totals['extra'])}", :align => :right }
    row << { :content => "#{number_to_format(totals['doble'])}", :align => :right }
    rows << row
    row = []

    # Total Devengado
    @total_devengado = totals['ordinario'].to_f + totals['extra'].to_f + totals['doble'].to_f
    row << { :content => "Total Devengado", :colspan => 3, :align => :right, :font_style => :bold }  
    row << { :content => "#{number_to_format(@total_devengado)}", :colspan => 3, :align => :right}
    rows << row
    row = []

    tRows << rows
    rows = []
    
    tRows
  end

  def get_data_deductions(employee_id)
      
    rows = []
    row = []
    result = []
    total = 0
    total_others = 0
    count = 0

    DeductionPayment.where('payroll_id = ?', @payroll.id).each do |a|
      if a.deduction_employee.employee_id.to_f == employee_id.to_f
        count += 1
        if count >= 4
          total_others += a.payment.to_f
          total += a.payment
        else
          if a.payment > 0
            row << "#{a.deduction_employee.deduction.description}"
            row << "#{a.deduction_employee.calculation}"
            row << "#{number_to_format(a.payment.to_f)}"
          end
          total += a.payment
        end
      end

      unless row.empty?
        if count < 4
          rows << row
          row = []
        end
      end
    end

    if total_others != 0
      row = []
      row << "Otros"
      row << "0"
      row << total_others
      rows << row
    else
      row << "N/A"
      row << "0.0"
      row << "0.0"
      rows << row
    end

    result << rows
    result << "#{total}"
  end

  def table_deductions(data, center)

    receive = @total_devengado.to_f - data[1].to_f
    receive = number_to_format(receive)

    if center
      aline = :center
      moveDown = move_down 15
    else
      aline = :right
      moveDown = ""
    end

    moveDown
    text "Deducciones Aplicadas", character_spacing: 1, :align => aline
    moveDown

    table([
      [
        { :content => "Deduccion", :font_style => :bold }, 
        { :content => "%", :font_style => :bold }, 
        { :content => "Monto", :font_style => :bold }
      ]] +
      data[0].map do |row| row end +
      [[ {:content => "Total Deducciones:", :colspan => 2, :font_style => :bold }, {:content => "#{data[1].to_f}"} ],
      [ {:content => "Total a Recibir:", :colspan => 2, :font_style => :bold }, {:content => "#{receive}"} ]],
      :cell_style => { :align => :right, :size => 10, :height => 19, :border_color => "FFFFFF" },
      :position => aline
    ) do
      row(0).borders = [:bottom]
      row(0).border_width = 2
      row(0).font_style = :bold
      row(0).border_color = "#000000"
    end
    move_down 15
    span(280,:position => aline) do
      text "#{@msg}", :size => 10
    end
  end

  def number_to_format(number)
    number_to_currency(number, :precision => 2, :format => "%u%n", :unit => "")
  end

  def is_numeric(string)
    if /^[\d]+(\.[\d]+){0,1}$/ === string
      true
    else
      false
    end    
  end

end
